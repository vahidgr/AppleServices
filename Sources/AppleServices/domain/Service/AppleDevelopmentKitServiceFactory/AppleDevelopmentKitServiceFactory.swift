import AppleDevelopmentKit

/// Creates AppleServices adapters for Apple's public APIs and bundles them for workflow injection.
public enum AppleServicesDependencyFactory {
    @MainActor
    public static func makeAppleDevelopmentKitServices(
        iCloudContainerIdentifier: String? = nil
    ) -> AppleDevelopmentKitServices {
        AppleDevelopmentKitServices(
            faceTimeCall: FaceTimeCallService(),
            iCloudAccount: ICloudAccountService(),
            calendarEvent: CalendarEventService(),
            reminder: ReminderService(),
            keychainPassword: KeychainPasswordService(),
            iCloudDocument: ICloudDocumentService(),
            iWorkDocumentExport: IWorkDocumentExportService(),
            messageCompose: MessageComposeService(),
            appURL: AppURLService(),
            cloudRecord: CloudRecordService(containerIdentifier: iCloudContainerIdentifier),
            observability: ObservabilityService()
        )
    }
}
