import Foundation
import Testing
import AppleDevelopmentKit
@testable import AppleServices

@Suite struct CalendarEventServiceTests {
    @Test @MainActor func rejectsEmptyTitleBeforeRequestingPermission() async {
        await #expect(throws: CalendarEventService.Failure.emptyTitle) {
            try await CalendarEventService().create(title: " ", startDate: .now, endDate: .now.addingTimeInterval(60))
        }
    }
    @Test @MainActor func rejectsInvalidDateRangeBeforeRequestingPermission() async {
        let now = Date.now
        await #expect(throws: CalendarEventService.Failure.invalidDateRange) {
            try await CalendarEventService().create(title: "Event", startDate: now, endDate: now)
        }
    }
}
