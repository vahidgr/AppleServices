# Framework coverage

This document explains what the `AppleServices` catalog indexes and what the umbrella module makes importable. The system frameworks remain the implementation: AppleServices does not copy their declarations or bypass their availability, permissions, entitlements, sandbox, or extension rules.

## Package surface

AppleDevelopmentKit owns the public service protocols and workflows. This package implements those protocols as the data layer and exports a public `AppleServicesDependencyFactory` that returns an `AppleDevelopmentKitServices` bundle. Applications can instead supply their own conforming implementations. The factory defaults to the system CloudKit container; pass an identifier to use a custom container.

### Catalog types

- `AppleServiceCatalog.services` returns all entries in stable order.
- `AppleServiceCatalog.service(named:)` finds a service by case-insensitive exact name.
- `AppleServiceCatalog.search(_:)` searches service names and each API’s name, framework, summary, and availability text by case-insensitive substring.
- `AppleService` and `AppleAPI` are immutable `Hashable`, `Sendable` value types.

### Re-exported modules

`AppleServices` conditionally re-exports: Foundation, Messages, GroupActivities, EventKit, EventKitUI, Security, AuthenticationServices, CloudKit, UserNotifications, AppIntents, UIKit, AppKit, and AppleScriptObjC. A module is exported only when it is available in the active SDK.

## Service-by-service notes

### Messages and iMessage

The Messages framework supports iMessage app and sticker extensions, interactive message payloads, and selected messaging integrations. A package cannot declare the app-extension target or its entitlements. The host app must add the extension, required privacy descriptions, and extension-specific UI. Third-party applications do not receive general access to the user’s Messages database.

Reference: [Messages](https://developer.apple.com/documentation/messages).

### FaceTime and SharePlay

FaceTime call URLs ask the system to open FaceTime. `GroupActivities` provides SharePlay sessions and synchronization for an app’s own activity. Apple does not provide a general API for controlling FaceTime calls or reading call history.

References: [FaceTime Links](https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/FacetimeLinks/FacetimeLinks.html), [GroupActivities](https://developer.apple.com/documentation/groupactivities).

### Calendar and Reminders

EventKit reads and modifies authorized event and reminder data. Newer OS versions distinguish write-only event access from full event access and full reminder access. Apps must include the matching purpose strings. EventKit UI components are platform-specific and must be presented by a host application.

References: [EventKit](https://developer.apple.com/documentation/eventkit), [EventKit UI](https://developer.apple.com/documentation/eventkitui), [accessing the event store](https://developer.apple.com/documentation/eventkit/accessing-the-event-store).

### Notes

Apple does not provide a public API for general CRUD access to the Notes database. Some macOS automation may be possible through Apple Events/AppleScript. App Intents let developers expose their own app’s operations to system experiences; they do not grant access to Notes content.

Reference: [Apple Developer Forums: Notes API](https://developer.apple.com/forums/thread/813810).

### Keychain and Password AutoFill

Security Keychain Services manage secrets owned by the calling app and groups authorized by entitlements. AuthenticationServices supports password/passkey authorization and credential provider extensions. An app cannot enumerate the Passwords app’s contents.

References: [Keychain Services](https://developer.apple.com/documentation/security/keychain_services), [Password AutoFill](https://developer.apple.com/documentation/security/password_autofill), [credential provider view controller](https://developer.apple.com/documentation/authenticationservices/ascredentialproviderviewcontroller).

### Pages, Numbers, and Keynote

Apple’s iWork Document Exporting API is an authenticated REST API that converts supported iWork documents to PDF. It is not a native SDK for arbitrary document editing. The service requires a configured Services ID and authorization key; it accepts document data for conversion. Some macOS automation may be available through each installed app’s scripting dictionary.

References: [iWork PDF export API](https://developer.apple.com/documentation/iworkdocumentexportingapi/create-an-export-job-%28v2%29), [iWork service configuration](https://developer.apple.com/help/account/service-configurations/iwork-document-exporting), [Mac Automation Scripting Guide](https://developer.apple.com/library/archive/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/).

### App Intents, delegates, and app opening

AppIntents defines actions, entities, foreground/background modes, and `OpenIntent`. UIKit and AppKit define platform app lifecycle and delegate APIs. Universal links need an associated domain and a correctly hosted `apple-app-site-association` file. These declarations must be integrated into the containing application; this package does not create that app target or its runtime configuration.

References: [App Intents](https://developer.apple.com/documentation/appintents/app-intents), [intent runtime behavior](https://developer.apple.com/documentation/appintents/configuring-the-runtime-behavior-of-your-app-intents), [UIKit launch](https://developer.apple.com/documentation/uikit/responding-to-the-launch-of-your-app), [universal links](https://developer.apple.com/documentation/xcode/allowing-apps-and-websites-to-link-to-your-content), [NSApplicationDelegate](https://developer.apple.com/documentation/appkit/nsapplicationdelegate).

### iCloud

CloudKit provides app-owned public, private, and shared databases. `CKSyncEngine` can manage record synchronization when the app supplies changes, a delegate, and persisted engine state. iCloud documents and `NSUbiquitousKeyValueStore` are different storage mechanisms with distinct limits and entitlements. No mechanism in this package syncs another Apple app’s private records.

References: [CloudKit](https://developer.apple.com/documentation/cloudkit), [CKSyncEngine](https://developer.apple.com/documentation/cloudkit/cksyncengine), [iCloud key-value store](https://developer.apple.com/documentation/foundation/nsubiquitouskeyvaluestore), [FileManager ubiquitous items](https://developer.apple.com/documentation/foundation/filemanager/setubiquitous(_:itemat:destinationurl:)).
