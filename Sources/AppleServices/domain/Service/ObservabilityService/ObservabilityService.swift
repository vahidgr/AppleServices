import AppleDevelopmentKit
public struct ObservabilityService: ObservabilityServiceProtocol, Sendable {
    public init() {}
    public func log(_ error: any Error) {
        #if DEBUG
        fputs("AppleDevelopmentKit: \(error)\n", stderr)
        #endif
    }
}
