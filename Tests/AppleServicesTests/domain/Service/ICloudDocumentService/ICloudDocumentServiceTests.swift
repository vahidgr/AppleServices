import Foundation
import Testing
import AppleDevelopmentKit
@testable import AppleServices

@Suite struct ICloudDocumentServiceTests {
    @Test func rejectsPathTraversalFilename() async {
        await #expect(throws: ICloudDocumentService.Failure.invalidFileName) {
            try await ICloudDocumentService().copy(sourceURL: URL(fileURLWithPath: "/tmp/source"), fileName: "../escape", containerIdentifier: nil)
        }
    }
}
