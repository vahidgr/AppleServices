import Foundation
import AppleDevelopmentKit
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

@MainActor
public struct AppURLService: AppURLServiceProtocol {
    public init() {}
    public func open(_ url: URL) async throws -> Bool {
        guard let scheme = url.scheme?.lowercased(), !["file", "data", "javascript"].contains(scheme) else {
            throw Failure.unsupportedURLScheme
        }
        #if canImport(UIKit)
        return await withCheckedContinuation { continuation in
            Task { @MainActor in
                UIApplication.shared.open(url, options: [:]) { success in continuation.resume(returning: success) }
            }
        }
        #elseif canImport(AppKit)
        return NSWorkspace.shared.open(url)
        #else
        throw Failure.unsupportedPlatform
        #endif
    }

    public enum Failure: Error, Equatable { case unsupportedURLScheme, unsupportedPlatform }
}
