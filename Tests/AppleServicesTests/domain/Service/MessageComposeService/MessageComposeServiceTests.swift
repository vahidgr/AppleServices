import Testing
import AppleDevelopmentKit
@testable import AppleServices

@Suite struct MessageComposeServiceTests {
    @Test func buildsSMSComposerURLWithEncodedBody() throws {
        let url = try MessageComposeService().makeURL(recipient: " +1-555-0100 ", body: "Hello & goodbye")
        #expect(url.scheme == "sms")
        #expect(url.path == "+1-555-0100")
        #expect(URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.first?.value == "Hello & goodbye")
    }
    @Test func rejectsEmptyAndInvalidRecipients() {
        #expect(throws: MessageComposeService.Failure.emptyRecipient) { try MessageComposeService().makeURL(recipient: " ", body: nil) }
        #expect(throws: MessageComposeService.Failure.invalidRecipient) { try MessageComposeService().makeURL(recipient: "not a number", body: nil) }
    }
}
