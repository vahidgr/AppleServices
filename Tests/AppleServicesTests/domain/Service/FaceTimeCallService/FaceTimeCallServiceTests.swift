import Foundation
import Testing
@testable import AppleServices

@Suite struct FaceTimeCallServiceTests {
    @Test func createsAudioAndVideoURLs() throws {
        let service = FaceTimeCallService()
        #expect(try service.makeURL(destination: "+14155550100", type: .audio).absoluteString == "facetime-audio://+14155550100")
        #expect(try service.makeURL(destination: "person@example.com", type: .video).absoluteString == "facetime://person@example.com")
    }

    @Test func rejectsEmptyAndUnsupportedDestinations() {
        let service = FaceTimeCallService()
        #expect(throws: FaceTimeCallService.Failure.emptyDestination) {
            try service.makeURL(destination: "  ", type: .video)
        }
        #expect(throws: FaceTimeCallService.Failure.unsupportedDestination) {
            try service.makeURL(destination: "not a destination", type: .audio)
        }
    }
}
