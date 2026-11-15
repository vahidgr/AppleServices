import Foundation

/// Searchable index of Apple-documented APIs related to the requested services.
public struct AppleServiceCatalog: Sendable {
    public init() {}

    public var services: [AppleService] { Self.catalog }

    public func service(named name: String) -> AppleService? {
        Self.catalog.first { $0.name.localizedCaseInsensitiveCompare(name) == .orderedSame }
    }

    /// Searches service names, API names, frameworks, and descriptions.
    public func search(_ query: String) -> [AppleAPI] {
        let needle = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !needle.isEmpty else { return [] }

        return Self.catalog.flatMap { service in
            service.apis.filter { api in
                service.name.localizedCaseInsensitiveContains(needle)
                    || [api.name, api.framework, api.summary, api.availability]
                        .contains { $0.localizedCaseInsensitiveContains(needle) }
            }
        }
    }

    private static let catalog: [AppleService] = [
        AppleService(name: "iMessage", summary: "Build Messages extensions and interactive message experiences; third-party apps cannot read a user's Messages database.", apis: [
            AppleAPI(name: "Messages apps and stickers", framework: "Messages", summary: "Create sticker packs and iMessage app extensions; compose text, stickers, and media into a conversation.", availability: "iOS/iPadOS app extension; received content may be viewed on other Apple platforms.", documentationURL: "https://developer.apple.com/documentation/messages"),
            AppleAPI(name: "Critical Messaging", framework: "Messages", summary: "Send critical SMS from eligible apps with the required authorization; this is SMS functionality, not general iMessage inbox access.", availability: "Platform, entitlement, and authorization restricted.", documentationURL: "https://developer.apple.com/documentation/messages"),
            AppleAPI(name: "Messages app extension", framework: "Messages", summary: "Use MSMessagesAppViewController, MSConversation, MSMessage, and MSSession to create and update interactive messages.", availability: "iOS/iPadOS Messages extension.", documentationURL: "https://developer.apple.com/documentation/messages"),
        ]),
        AppleService(name: "FaceTime", summary: "Integrate user-initiated FaceTime calls or build SharePlay activities; no public API exposes FaceTime call controls or history.", apis: [
            AppleAPI(name: "FaceTime links", framework: "URL schemes", summary: "Open FaceTime for an audio or video call using a phone number or email address.", availability: "System handles the call; user confirmation behavior varies by platform.", documentationURL: "https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/FacetimeLinks/FacetimeLinks.html"),
            AppleAPI(name: "SharePlay and Group Activities", framework: "GroupActivities", summary: "Offer coordinated shared experiences over FaceTime using GroupActivity and GroupSession.", availability: "Requires the Group Activities capability and entitlement; not available in extensions or App Clips.", documentationURL: "https://developer.apple.com/documentation/groupactivities"),
        ]),
        AppleService(name: "Calendar", summary: "Read and write authorized calendar events through EventKit.", apis: [
            AppleAPI(name: "Calendar events", framework: "EventKit", summary: "Request write-only or full access, fetch events, create and edit events, manage recurrence and alarms, and observe store changes.", availability: "Requires purpose strings and user authorization; sandboxed macOS apps also need the Calendar entitlement.", documentationURL: "https://developer.apple.com/documentation/eventkit"),
            AppleAPI(name: "Calendar UI", framework: "EventKitUI", summary: "Present system interfaces for viewing, editing, and choosing calendar events and calendars.", availability: "System UI availability differs by platform; primarily documented for iOS.", documentationURL: "https://developer.apple.com/documentation/eventkitui"),
        ]),
        AppleService(name: "Notes", summary: "There is no public cross-platform API to CRUD the Apple Notes database.", apis: [
            AppleAPI(name: "Notes automation", framework: "Apple Events / AppleScript", summary: "Some macOS Notes automation is possible through its scripting dictionary; it is not a supported cross-platform Notes data API.", availability: "macOS only; scripting terms and behavior can vary with app versions.", documentationURL: "https://developer.apple.com/forums/thread/813810"),
            AppleAPI(name: "App Intents integration", framework: "AppIntents", summary: "Expose your app's own actions and data to Shortcuts and system experiences; this does not grant access to Notes contents.", availability: "Supported Apple platforms according to the framework's availability.", documentationURL: "https://developer.apple.com/documentation/appintents"),
        ]),
        AppleService(name: "Reminders", summary: "Read and write authorized reminder lists and tasks through EventKit.", apis: [
            AppleAPI(name: "Reminders", framework: "EventKit", summary: "Request full reminders access, fetch and modify reminders, lists, due dates, recurrence, alarms, and completion state.", availability: "Requires NSRemindersFullAccessUsageDescription and user authorization; access level depends on OS version.", documentationURL: "https://developer.apple.com/documentation/eventkit"),
        ]),
        AppleService(name: "Keychain / Passwords", summary: "Apps can access their own Keychain items and authorized shared groups, not browse the user's Passwords app database.", apis: [
            AppleAPI(name: "Keychain Services", framework: "Security", summary: "Add, find, update, and delete an app's passwords, keys, certificates, and identities with SecItem APIs.", availability: "All Apple platforms; access is constrained by app identity, entitlements, access groups, and user authentication.", documentationURL: "https://developer.apple.com/documentation/security/keychain_services"),
            AppleAPI(name: "Password AutoFill", framework: "AuthenticationServices / Security", summary: "Support AutoFill in your sign-in forms using associated domains and the appropriate content types.", availability: "System-mediated; credentials are suggested for matching domains after user authentication.", documentationURL: "https://developer.apple.com/documentation/security/password_autofill"),
            AppleAPI(name: "Credential Provider Extension", framework: "AuthenticationServices", summary: "Implement a password manager extension to provide passwords, passkeys, one-time codes, and supported credential exchange to AutoFill.", availability: "Requires a credential provider extension and the AutoFill Credential Provider entitlement.", documentationURL: "https://developer.apple.com/documentation/authenticationservices/ascredentialproviderviewcontroller"),
        ]),
        AppleService(name: "Pages", summary: "Pages does not expose a general-purpose native document editing framework to third-party apps.", apis: [
            AppleAPI(name: "iWork Document Exporting", framework: "iWork REST API", summary: "Export supported iWork documents, including Pages documents, to PDF through Apple's web service.", availability: "Requires Apple Developer Program membership, a configured Services ID, and authorization key.", documentationURL: "https://developer.apple.com/documentation/iworkdocumentexportingapi/create-an-export-job-%28v2%29"),
            AppleAPI(name: "Pages automation", framework: "Apple Events / AppleScript", summary: "Use the installed app's scripting dictionary where available for macOS automation.", availability: "macOS only; limited to commands exposed by that Pages version.", documentationURL: "https://developer.apple.com/library/archive/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/"),
        ]),
        AppleService(name: "Numbers", summary: "Numbers does not expose a general-purpose native document editing framework to third-party apps.", apis: [
            AppleAPI(name: "iWork Document Exporting", framework: "iWork REST API", summary: "Export supported iWork documents, including Numbers spreadsheets, to PDF through Apple's web service.", availability: "Requires Apple Developer Program membership, a configured Services ID, and authorization key.", documentationURL: "https://developer.apple.com/documentation/iworkdocumentexportingapi/create-an-export-job-%28v2%29"),
            AppleAPI(name: "Numbers automation", framework: "Apple Events / AppleScript", summary: "Use the installed app's scripting dictionary where available for macOS automation.", availability: "macOS only; limited to commands exposed by that Numbers version.", documentationURL: "https://developer.apple.com/library/archive/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/"),
        ]),
        AppleService(name: "Keynote", summary: "Keynote does not expose a general-purpose native document editing framework to third-party apps.", apis: [
            AppleAPI(name: "iWork Document Exporting", framework: "iWork REST API", summary: "Export supported iWork documents, including Keynote presentations, to PDF through Apple's web service.", availability: "Requires Apple Developer Program membership, a configured Services ID, and authorization key.", documentationURL: "https://developer.apple.com/documentation/iworkdocumentexportingapi/create-an-export-job-%28v2%29"),
            AppleAPI(name: "Keynote automation", framework: "Apple Events / AppleScript", summary: "Use the installed app's scripting dictionary where available for macOS automation.", availability: "macOS only; limited to commands exposed by that Keynote version.", documentationURL: "https://developer.apple.com/library/archive/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/"),
        ]),
        AppleService(name: "App Intents", summary: "Expose an app's own actions and entities to system experiences, with configurable foreground behavior.", apis: [
            AppleAPI(name: "AppIntent", framework: "AppIntents", summary: "Define actions, parameters, results, and supported foreground/background execution modes for Shortcuts and system experiences.", availability: "The intent runs according to its type, target, mode, and system context; extensions run intents in the background.", documentationURL: "https://developer.apple.com/documentation/appintents/app-intents"),
            AppleAPI(name: "OpenIntent", framework: "AppIntents", summary: "Open the app to a specific app entity or item. The system brings the app to the foreground.", availability: "Intent types that open the app belong in the app target, not a generic App Intents extension.", documentationURL: "https://developer.apple.com/documentation/appintents/openintent"),
            AppleAPI(name: "Intent execution modes", framework: "AppIntents", summary: "Use supportedModes to request background, immediate foreground, dynamic, or deferred foreground execution.", availability: "The system treats modes as guidance and may choose another execution context.", documentationURL: "https://developer.apple.com/documentation/appintents/configuring-the-runtime-behavior-of-your-app-intents"),
        ]),
        AppleService(name: "App Launch & Delegates", summary: "Handle ordinary launches, app and scene lifecycle events, URL schemes, and universal links in the app target.", apis: [
            AppleAPI(name: "UIKit app and scene lifecycle", framework: "UIKit", summary: "Use UIApplicationDelegate and UISceneDelegate for process launch, scene connection, lifecycle, and incoming URLs or user activities.", availability: "iOS/iPadOS; scene connection supplies launch context when scene lifecycle is enabled.", documentationURL: "https://developer.apple.com/documentation/uikit/responding-to-the-launch-of-your-app"),
            AppleAPI(name: "AppKit application lifecycle", framework: "AppKit", summary: "Use NSApplicationDelegate to receive macOS launch, activation, termination, and URL/open-document events.", availability: "macOS app target.", documentationURL: "https://developer.apple.com/documentation/appkit/nsapplicationdelegate"),
            AppleAPI(name: "Universal links", framework: "UIKit / AppKit", summary: "Route verified HTTPS links into the app and handle the delivered user activity or URL.", availability: "Requires associated-domains entitlement and a valid apple-app-site-association file on the domain.", documentationURL: "https://developer.apple.com/documentation/xcode/allowing-apps-and-websites-to-link-to-your-content"),
        ]),
        AppleService(name: "iCloud Sync", summary: "Sync data owned by your app through CloudKit, iCloud documents, or the iCloud key-value store.", apis: [
            AppleAPI(name: "CloudKit databases", framework: "CloudKit", summary: "Access the app's public, private, and shared databases through CKContainer and CKDatabase.", availability: "Private and shared databases require an active iCloud account and configured iCloud container entitlement.", documentationURL: "https://developer.apple.com/documentation/cloudkit/ckcontainer"),
            AppleAPI(name: "CKSyncEngine", framework: "CloudKit", summary: "Synchronize app-owned records with private or shared CloudKit databases using a delegate and persisted engine state.", availability: "Requires CloudKit and remote-notification entitlements; sync timing is system-controlled.", documentationURL: "https://developer.apple.com/documentation/cloudkit/cksyncengine"),
            AppleAPI(name: "iCloud key-value store", framework: "Foundation", summary: "Synchronize small app preferences and state using NSUbiquitousKeyValueStore.", availability: "Requires the iCloud key-value store entitlement; limited to property-list values and 1 MB total storage.", documentationURL: "https://developer.apple.com/documentation/foundation/nsubiquitouskeyvaluestore"),
            AppleAPI(name: "iCloud Documents", framework: "Foundation", summary: "Store app documents in an app's ubiquitous container and coordinate file access across devices.", availability: "Requires an iCloud container entitlement and file coordination; sync is asynchronous.", documentationURL: "https://developer.apple.com/documentation/foundation/filemanager/setubiquitous(_:itemat:destinationurl:)"),
        ]),
    ]
}
