import Foundation
import AppleDevelopmentKit

public struct ICloudDocumentService: ICloudDocumentServiceProtocol {
    public init() {}
    public func list(containerIdentifier: String?) async throws -> [URL] {
        let directory = try documentsDirectory(containerIdentifier: containerIdentifier)
        let coordinator = NSFileCoordinator(filePresenter: nil)
        var coordinationError: NSError?
        var result: Result<[URL], Error>?
        coordinator.coordinate(readingItemAt: directory, options: .withoutChanges, error: &coordinationError) { coordinatedURL in
            result = Result {
                try FileManager.default.contentsOfDirectory(
                    at: coordinatedURL,
                    includingPropertiesForKeys: [.isRegularFileKey],
                    options: [.skipsHiddenFiles]
                )
            }
        }
        if let coordinationError { throw coordinationError }
        guard let result else { throw Failure.unavailable }
        return try result.get()
    }

    public func copy(sourceURL: URL, fileName: String, containerIdentifier: String?) async throws -> URL {
        guard !fileName.isEmpty, URL(fileURLWithPath: fileName).lastPathComponent == fileName else { throw Failure.invalidFileName }
        let directory = try documentsDirectory(containerIdentifier: containerIdentifier)
        let destination = directory.appendingPathComponent(fileName)
        let didStartAccess = sourceURL.startAccessingSecurityScopedResource()
        defer { if didStartAccess { sourceURL.stopAccessingSecurityScopedResource() } }
        let coordinator = NSFileCoordinator(filePresenter: nil)
        var coordinationError: NSError?
        var copyError: Error?
        coordinator.coordinate(readingItemAt: sourceURL, options: [], writingItemAt: destination, options: [], error: &coordinationError) { coordinatedSource, coordinatedDestination in
            do { try FileManager.default.copyItem(at: coordinatedSource, to: coordinatedDestination) }
            catch { copyError = error }
        }
        if let coordinationError { throw coordinationError }
        if let copyError { throw copyError }
        return destination
    }

    public func download(url: URL) async throws {
        try FileManager.default.startDownloadingUbiquitousItem(at: url)
    }

    private func documentsDirectory(containerIdentifier: String?) throws -> URL {
        guard let container = FileManager.default.url(forUbiquityContainerIdentifier: containerIdentifier) else { throw Failure.unavailable }
        let documents = container.appendingPathComponent("Documents", isDirectory: true)
        try FileManager.default.createDirectory(at: documents, withIntermediateDirectories: true)
        return documents
    }

    public enum Failure: Error, Equatable { case unavailable, invalidFileName }
}
