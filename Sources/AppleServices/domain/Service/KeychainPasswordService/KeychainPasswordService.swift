import AppleDevelopmentKit
import Security
import Foundation

public struct KeychainPasswordService: KeychainPasswordServiceProtocol {
    public init() {}
    public func store(service: String, account: String, password: Data) async throws {
        guard !service.isEmpty, !account.isEmpty, !password.isEmpty else { throw Failure.invalidInput }
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: service,
                                    kSecAttrAccount as String: account]
        let update = [kSecValueData as String: password]
        let updateStatus = SecItemUpdate(query as CFDictionary, update as CFDictionary)
        if updateStatus == errSecSuccess { return }
        guard updateStatus == errSecItemNotFound else { throw Failure.status(updateStatus) }
        var add = query
        add[kSecValueData as String] = password
        let addStatus = SecItemAdd(add as CFDictionary, nil)
        guard addStatus == errSecSuccess else { throw Failure.status(addStatus) }
    }

    public func read(service: String, account: String) async throws -> Data {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: service,
                                    kSecAttrAccount as String: account,
                                    kSecReturnData as String: true,
                                    kSecMatchLimit as String: kSecMatchLimitOne]
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data else { throw Failure.status(status) }
        return data
    }

    public func delete(service: String, account: String) async throws {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: service,
                                    kSecAttrAccount as String: account]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw Failure.status(status) }
    }

    public enum Failure: Error, Equatable { case invalidInput, status(OSStatus) }
}
