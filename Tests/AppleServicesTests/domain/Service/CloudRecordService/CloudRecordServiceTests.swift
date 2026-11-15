import Foundation
import Testing
import AppleDevelopmentKit
@testable import AppleServices

@Suite struct CloudRecordServiceTests {
    @Test func rejectsInvalidRecordIdentityBeforeCloudKitAccess() async {
        await #expect(throws: CloudRecordService.Failure.invalidRecordIdentity) {
            try await CloudRecordService().save(scope: .private, recordType: "", recordName: "id", payload: Data())
        }
    }
}
