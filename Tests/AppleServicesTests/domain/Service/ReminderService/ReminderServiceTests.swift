import Testing
import AppleDevelopmentKit
@testable import AppleServices

@Suite struct ReminderServiceTests {
    @Test @MainActor func rejectsEmptyTitleBeforeRequestingPermission() async {
        await #expect(throws: ReminderService.Failure.emptyTitle) {
            try await ReminderService().create(title: "  ", dueDate: nil)
        }
    }
}
