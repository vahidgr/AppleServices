import Foundation
import AppleDevelopmentKit

public struct MessageComposeService: MessageComposeServiceProtocol {
    public init() {}
    public func makeURL(recipient: String, body: String?) throws -> URL {
        let trimmed = recipient.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw Failure.emptyRecipient }
        let allowed = CharacterSet(charactersIn: "+0123456789-().")
        guard trimmed.unicodeScalars.allSatisfy(allowed.contains) else { throw Failure.invalidRecipient }
        var components = URLComponents()
        components.scheme = "sms"
        components.path = trimmed
        if let body, !body.isEmpty { components.queryItems = [URLQueryItem(name: "body", value: body)] }
        guard let url = components.url else { throw Failure.invalidRecipient }
        return url
    }

    public enum Failure: Error, Equatable { case emptyRecipient, invalidRecipient }
}
