import CryptoKit
import Foundation
import AppleDevelopmentKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct IWorkDocumentExportService: IWorkDocumentExportServiceProtocol {
    private let session: URLSession
    public init(session: URLSession = .shared) { self.session = session }

    public func exportPDF(documentURL: URL, fileName: String, credentials: IWorkExportCredentials) async throws -> URL {
        let ext = URL(fileURLWithPath: fileName).pathExtension.lowercased()
        guard ["pages", "numbers", "key"].contains(ext), !fileName.isEmpty else { throw Failure.unsupportedDocument }
        let values = try documentURL.resourceValues(forKeys: [.fileSizeKey])
        guard let size = values.fileSize, size > 0, size <= 1_000_000_000 else { throw Failure.invalidFileSize }
        let token = try makeToken(fileName: fileName, credentials: credentials)
        var request = URLRequest(url: URL(string: "https://iworkpreviewapi.icloud.com/iwork/api/v2/export")!)
        request.httpMethod = "POST"
        request.setValue(token, forHTTPHeaderField: "authorization")
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        let (data, response) = try await session.upload(for: request, fromFile: documentURL)
        guard let response = response as? HTTPURLResponse else { throw Failure.invalidResponse }
        guard response.statusCode == 200 else { throw Failure.httpStatus(response.statusCode) }
        guard !data.isEmpty else { throw Failure.invalidResponse }
        let output = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("pdf")
        try data.write(to: output, options: .atomic)
        return output
    }

    private func base64URLString(_ data: Data) -> String {
        data.base64EncodedString().replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_").replacingOccurrences(of: "=", with: "")
    }

    public func makeToken(fileName: String, credentials: IWorkExportCredentials) throws -> String {
        guard !credentials.teamIdentifier.isEmpty, !credentials.keyIdentifier.isEmpty else { throw Failure.invalidCredentials }
        let key = try P256.Signing.PrivateKey(pemRepresentation: credentials.privateKeyPEM)
        let issuedAt = Int(Date().timeIntervalSince1970)
        let header: [String: String] = ["alg": "ES256", "kid": credentials.keyIdentifier]
        let payload: [String: Any] = [
            "iss": credentials.teamIdentifier,
            "encoded_filename": base64URLString(Data(fileName.utf8)),
            "export_format": "com.adobe.pdf",
            "iat": issuedAt,
            "exp": issuedAt + 14_400
        ]
        let encoder = JSONEncoder()
        let headerData = try encoder.encode(header)
        let payloadData = try JSONSerialization.data(withJSONObject: payload, options: [.sortedKeys])
        let unsigned = "\(base64URLString(headerData)).\(base64URLString(payloadData))"
        let signature = try key.signature(for: Data(unsigned.utf8))
        return "\(unsigned).\(base64URLString(signature.rawRepresentation))"
    }

    public enum Failure: Error, Equatable { case unsupportedDocument, invalidFileSize, invalidCredentials, invalidResponse, httpStatus(Int) }
}
