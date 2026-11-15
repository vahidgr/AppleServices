# AppleServices

AppleServices is the data-layer package for AppleDevelopmentKit. It implements the domain service protocols using public Apple APIs, provides a ready-to-use dependency factory, indexes documented APIs, and re-exports related native SDK frameworks.

## Requirements

- Swift 6.4 or later
- Xcode and the Apple SDKs for the platforms you build
- iOS/iPadOS 17 or later
- macOS 14 or later

The package does not set a deployment target. Each re-exported symbol retains the platform and OS availability declared by Apple’s SDK.

## Add the package

In Xcode, choose **File → Add Package Dependencies** and enter this repository’s URL. In a Swift package manifest:

```swift
dependencies: [
    .package(url: "https://github.com/vahidgr/AppleServices.git", from: "1.0.0")
]
```

Then add the `AppleServices` product to the target and import the module:

```swift
import AppleServices

let catalog = AppleServiceCatalog()
let calendar = catalog.service(named: "Calendar")
let eventKitAPIs = catalog.search("EventKit")
```

## Adapter workflows

AppleDevelopmentKit owns the service protocols and workflow logic. AppleServices depends on those protocols and provides concrete implementations. Add both package products to your app target to use the bundled workflows:

```swift
dependencies: [
    .package(url: "https://github.com/vahidgr/AppleDevelopmentKit.git", from: "3.0.0"),
    .package(url: "https://github.com/vahidgr/AppleServices.git", from: "2.0.0")
]
```

```swift
import AppleDevelopmentKit
import AppleServices

let adapters = await AppleServicesDependencyFactory.makeAppleDevelopmentKitServices(
    iCloudContainerIdentifier: "iCloud.com.example.app"
)
let workflows = await AppleServiceStateContainer(services: adapters)
await workflows.send(.checkICloudAccount)
```

The factory and every concrete adapter are public. Apps can also construct `AppleDevelopmentKitServices` with their own implementations of the protocols. The bundle supports FaceTime URL creation, Messages composer URL creation, Calendar events, Reminders, Keychain passwords, iCloud documents, CloudKit records/account status, app URL opening, and iWork PDF export. Host-app entitlements, permissions, App Intents, delegates, Notes integrations, and iCloud synchronization policy remain app-owned.

## Public catalog API

`AppleServiceCatalog` exposes three read-only operations:

| API | Behavior |
| --- | --- |
| `services` | Returns the catalog’s service entries in stable display order. |
| `service(named:)` | Finds a service by case-insensitive name; returns `nil` if it is unknown. |
| `search(_:)` | Case-insensitive substring search over service names, API names, frameworks, summaries, and availability notes. Empty or whitespace-only queries return no results. |

`AppleService` contains a name, summary, and API entries. `AppleAPI` contains the integration name, framework or mechanism, summary, availability/permission notes, and Apple documentation URL. These immutable `Sendable` value types can be displayed or serialized by the client.

## Frameworks made available by `import AppleServices`

The module conditionally re-exports frameworks available in the current SDK: Foundation, Messages, GroupActivities, EventKit, EventKitUI, Security, AuthenticationServices, CloudKit, UserNotifications, AppIntents, UIKit, AppKit, and AppleScriptObjC. This makes Apple’s native APIs available from one package import; it does not wrap, replace, or expand them.

## Service coverage and limits

| Service | Public integration surface indexed here | Important limit |
| --- | --- | --- |
| iMessage | Messages apps and sticker extensions; interactive messages; critical messaging | Messages extensions require an app/extension target. Third-party apps cannot read the Messages database. |
| FaceTime | `facetime` URL schemes; GroupActivities / SharePlay | The host app must open the URL after a user action. There is no public API for FaceTime call history or controls. |
| Calendar | EventKit; EventKitUI | Requires usage descriptions, authorization, and (for sandboxed macOS apps) the Calendar entitlement. |
| Notes | macOS Apple Events/AppleScript automation; App Intents for a developer’s own app | Apple does not provide a public cross-platform Notes database CRUD API. |
| Reminders | EventKit reminders | Requires a reminders usage description and user authorization. |
| Keychain / Passwords | Security Keychain Services; AuthenticationServices AutoFill and credential-provider APIs | Apps access their own or entitled shared Keychain items; there is no API to browse the Passwords app’s database. |
| Pages, Numbers, Keynote | iWork Document Exporting REST API; macOS automation where supported | The REST API creates PDF previews; it is not a general document editing API. |
| App Intents and app lifecycle | AppIntents; UIKit/AppKit delegates and launch routing | The host app supplies its own actions, entities, scene configuration, URL handling, and capabilities. |
| iCloud | CloudKit, `CKSyncEngine`, iCloud documents, and ubiquitous key-value storage | Requires app-specific containers, entitlements, records, and sync-state handling. Sync timing is system-controlled. |

The catalog is a navigational index, not a generated symbol-by-symbol duplicate of the SDK. Use each linked Apple reference for complete declarations, availability, and current configuration requirements. Apple-private frameworks and APIs are intentionally excluded.

## Build and test

From this package directory:

```sh
swift test
```

The test target uses Swift Testing. Cross-build for iOS Simulator and macOS with the Xcode/SwiftPM toolchain appropriate to your installed SDKs.

See [Framework Coverage](Documentation/FrameworkCoverage.md) for per-framework notes and links.
