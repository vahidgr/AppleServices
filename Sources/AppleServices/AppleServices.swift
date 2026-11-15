/// Import AppleServices to make its supported public Apple SDK frameworks
/// available through one package import. Frameworks remain native Apple APIs:
/// their availability, authorization, entitlements, and extension requirements
/// continue to apply.
#if canImport(Messages)
@_exported import Messages
#endif

@_exported import Foundation

#if canImport(GroupActivities)
@_exported import GroupActivities
#endif

#if canImport(EventKit)
@_exported import EventKit
#endif

#if canImport(EventKitUI)
@_exported import EventKitUI
#endif

#if canImport(Security)
@_exported import Security
#endif

#if canImport(AuthenticationServices)
@_exported import AuthenticationServices
#endif

#if canImport(CloudKit)
@_exported import CloudKit
#endif

#if canImport(UserNotifications)
@_exported import UserNotifications
#endif

#if canImport(AppIntents)
@_exported import AppIntents
#endif

#if canImport(UIKit)
@_exported import UIKit
#endif

#if canImport(AppKit)
@_exported import AppKit
#endif

#if canImport(AppleScriptObjC)
@_exported import AppleScriptObjC
#endif
