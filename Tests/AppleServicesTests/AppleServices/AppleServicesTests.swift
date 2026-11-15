import Testing
import AppleServices

struct AppleServicesTests {
    @Test func reexportsNativeFrameworkInterfaces() {
        let _: EKEventStore.Type = EKEventStore.self
        let _: CKContainer.Type = CKContainer.self
        let _: ASAuthorizationController.Type = ASAuthorizationController.self
    }
}
