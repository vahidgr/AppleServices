import Foundation
import Testing
import AppleDevelopmentKit
@testable import AppleServices

@Suite struct KeychainPasswordServiceTests {
    @Test func storesReadsUpdatesAndDeletesAnAppOwnedPassword() async throws {
        let service = KeychainPasswordService()
        let account = UUID().uuidString
        try await service.store(service: "AppleDevelopmentKitTests", account: account, password: Data("first".utf8))
        try await service.store(service: "AppleDevelopmentKitTests", account: account, password: Data("second".utf8))
        #expect(try await service.read(service: "AppleDevelopmentKitTests", account: account) == Data("second".utf8))
        try await service.delete(service: "AppleDevelopmentKitTests", account: account)
        await #expect(throws: KeychainPasswordService.Failure.self) {
            try await service.read(service: "AppleDevelopmentKitTests", account: account)
        }
    }
    @Test func rejectsEmptyKeychainValues() async {
        await #expect(throws: KeychainPasswordService.Failure.invalidInput) {
            try await KeychainPasswordService().store(service: "", account: "user", password: Data([1]))
        }
    }
}
