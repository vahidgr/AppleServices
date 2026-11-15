import Foundation
import Testing
import AppleDevelopmentKit
@testable import AppleServices

@Suite struct AppURLServiceTests {
    @Test func rejectsUnsafeURLSchemes() async {
        await #expect(throws: AppURLService.Failure.unsupportedURLScheme) {
            try await AppURLService().open(URL(string: "javascript:alert(1)")!)
        }
    }
}
