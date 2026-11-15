import Foundation
import AppleDevelopmentKit
import EventKit

@MainActor
public struct ReminderService: ReminderServiceProtocol {
    public init() {}
    public func create(title: String, dueDate: Date?) async throws -> String {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw Failure.emptyTitle }
        let store = EKEventStore()
        guard try await store.requestFullAccessToReminders() else { throw Failure.accessDenied }
        guard let calendar = store.defaultCalendarForNewReminders() else { throw Failure.noWritableCalendar }
        let reminder = EKReminder(eventStore: store)
        reminder.title = title
        reminder.calendar = calendar
        if let dueDate {
            reminder.dueDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
        }
        try store.save(reminder, commit: true)
        let identifier = reminder.calendarItemIdentifier
        guard !identifier.isEmpty else { throw Failure.missingIdentifier }
        return identifier
    }

    public enum Failure: Error, Equatable {
        case emptyTitle, accessDenied, noWritableCalendar, missingIdentifier
    }
}
