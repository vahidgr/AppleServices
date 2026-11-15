import Foundation
import AppleDevelopmentKit
import EventKit

@MainActor
public struct CalendarEventService: CalendarEventServiceProtocol {
    public init() {}
    public func create(title: String, startDate: Date, endDate: Date) async throws -> String {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw Failure.emptyTitle }
        guard endDate > startDate else { throw Failure.invalidDateRange }
        let store = EKEventStore()
        guard try await store.requestWriteOnlyAccessToEvents() else { throw Failure.accessDenied }
        let event = EKEvent(eventStore: store)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        guard let calendar = store.defaultCalendarForNewEvents else { throw Failure.noWritableCalendar }
        event.calendar = calendar
        try store.save(event, span: .thisEvent)
        guard let identifier = event.eventIdentifier else { throw Failure.missingIdentifier }
        return identifier
    }

    public enum Failure: Error, Equatable {
        case emptyTitle, invalidDateRange, accessDenied, noWritableCalendar, missingIdentifier
    }
}
