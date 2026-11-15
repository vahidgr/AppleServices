import AppleDevelopmentKit
import CloudKit

public struct ICloudAccountService: ICloudAccountServiceProtocol {
    public init() {}
    public func accountStatus() async throws -> String {
        let status = try await CKContainer.default().accountStatus()
        return switch status {
        case .available: "available"
        case .noAccount: "noAccount"
        case .restricted: "restricted"
        case .temporarilyUnavailable: "temporarilyUnavailable"
        case .couldNotDetermine: "couldNotDetermine"
        @unknown default: "unknown"
        }
    }
}
