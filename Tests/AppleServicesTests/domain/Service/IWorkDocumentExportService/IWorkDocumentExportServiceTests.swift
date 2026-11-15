import Foundation
import Testing
import AppleDevelopmentKit
@testable import AppleServices

@Suite struct IWorkDocumentExportServiceTests {
    @Test func rejectsUnsupportedFileTypeBeforeNetworkRequest() async {
        await #expect(throws: IWorkDocumentExportService.Failure.unsupportedDocument) {
            try await IWorkDocumentExportService().exportPDF(
                documentURL: URL(fileURLWithPath: "/tmp/document.txt"), fileName: "document.txt",
                credentials: .init(teamIdentifier: "team", keyIdentifier: "key", privateKeyPEM: "invalid")
            )
        }
    }
}

import CryptoKit

extension IWorkDocumentExportServiceTests {
    @Test func createsVerifiableES256ExportToken() throws {
        let privateKey = P256.Signing.PrivateKey()
        let token = try IWorkDocumentExportService().makeToken(
            fileName: "Quarterly numbers.numbers",
            credentials: .init(teamIdentifier: "TEAM1", keyIdentifier: "KEY1", privateKeyPEM: privateKey.pemRepresentation)
        )
        let parts = token.split(separator: ".")
        #expect(parts.count == 3)
        let headerData = try #require(Data(base64URL: String(parts[0])))
        let payloadData = try #require(Data(base64URL: String(parts[1])))
        let header = try #require(JSONSerialization.jsonObject(with: headerData) as? [String: String])
        let payload = try #require(JSONSerialization.jsonObject(with: payloadData) as? [String: Any])
        #expect(header["alg"] == "ES256")
        #expect(header["kid"] == "KEY1")
        #expect(payload["iss"] as? String == "TEAM1")
        #expect(payload["encoded_filename"] as? String == Data("Quarterly numbers.numbers".utf8).base64URLSafe)
        #expect(payload["export_format"] as? String == "com.adobe.pdf")
        let signatureData = try #require(Data(base64URL: String(parts[2])))
        let signature = try P256.Signing.ECDSASignature(rawRepresentation: signatureData)
        let signedInput = Data("\(parts[0]).\(parts[1])".utf8)
        #expect(privateKey.publicKey.isValidSignature(signature, for: signedInput))
    }

    @Test func rejectsMissingSigningCredentials() {
        let key = P256.Signing.PrivateKey()
        #expect(throws: IWorkDocumentExportService.Failure.invalidCredentials) {
            try IWorkDocumentExportService().makeToken(
                fileName: "file.pages",
                credentials: .init(teamIdentifier: "", keyIdentifier: "key", privateKeyPEM: key.pemRepresentation)
            )
        }
    }
}

private extension Data {
    init?(base64URL: String) {
        let padded = base64URL.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/")
        self.init(base64Encoded: padded.padding(toLength: ((padded.count + 3) / 4) * 4, withPad: "=", startingAt: 0))
    }
    var base64URLSafe: String {
        base64EncodedString().replacingOccurrences(of: "+", with: "-").replacingOccurrences(of: "/", with: "_").replacingOccurrences(of: "=", with: "")
    }
}
