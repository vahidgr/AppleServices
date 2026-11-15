import Foundation
import AppleDevelopmentKit

public struct FaceTimeCallService: FaceTimeCallServiceProtocol, Sendable {
    public init() {}
    public enum Failure: Error, Equatable {
        case emptyDestination
        case unsupportedDestination
    }

    public func makeURL(destination: String, type: FaceTimeCallType) throws -> URL {
        let recipient = destination.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !recipient.isEmpty else { throw Failure.emptyDestination }

        let allowedCharacters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "@+.-()#*"))
        guard recipient.unicodeScalars.allSatisfy(allowedCharacters.contains) else {
            throw Failure.unsupportedDestination
        }

        let scheme = type == .audio ? "facetime-audio" : "facetime"
        guard let url = URL(string: "\(scheme)://\(recipient)") else {
            throw Failure.unsupportedDestination
        }
        return url
    }
}
