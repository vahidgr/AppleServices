import Testing
@testable import AppleServices

struct AppleServiceCatalogTests {
    private let catalog = AppleServiceCatalog()

    @Test func containsRequestedServices() {
        #expect(catalog.services.map(\.name) == [
            "iMessage", "FaceTime", "Calendar", "Notes", "Reminders",
            "Keychain / Passwords", "Pages", "Numbers", "Keynote",
            "App Intents", "App Launch & Delegates", "iCloud Sync",
        ])
    }

    @Test func looksUpServicesWithoutCaseSensitivity() {
        #expect(catalog.service(named: "facetime")?.name == "FaceTime")
        #expect(catalog.service(named: "unknown") == nil)
    }

    @Test func searchesFrameworksAndDescriptions() {
        #expect(catalog.search("eventkit").count == 3)
        #expect(catalog.search("FaceTime").contains { $0.name == "SharePlay and Group Activities" })
        #expect(catalog.search("no matching API").isEmpty)
    }

    @Test func emptyOrWhitespaceSearchReturnsNoResults() {
        #expect(catalog.search("").isEmpty)
        #expect(catalog.search("  \n ").isEmpty)
    }
}
