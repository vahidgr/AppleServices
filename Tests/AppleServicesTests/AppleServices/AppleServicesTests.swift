import Testing
import AppleServices

struct AppleServicesTests {
    @Test func reexportsNativeFrameworkInterfaces() {
        let _: EKEventStore.Type = EKEventStore.self
        let _: CKContainer.Type = CKContainer.self
        let _: ASAuthorizationController.Type = ASAuthorizationController.self
    }

    @MainActor
    @Test func dependencyFactoryProvidesUsablePublicAdapters() throws {
        let services = AppleServicesDependencyFactory.makeAppleDevelopmentKitServices()
        let url = try services.faceTimeCall.makeURL(destination: "person@example.com", type: .video)
        #expect(url.absoluteString == "facetime://person@example.com")
    }
}
