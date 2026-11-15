// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "AppleServices",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "AppleServices", targets: ["AppleServices"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vahidgr/AppleDevelopmentKit.git", from: "3.0.0"),
    ],
    targets: [
        .target(
            name: "AppleServices",
            dependencies: [.product(name: "AppleDevelopmentKit", package: "AppleDevelopmentKit")],
            swiftSettings: [.enableUpcomingFeature("ApproachableConcurrency")]
        ),
        .testTarget(
            name: "AppleServicesTests",
            dependencies: ["AppleServices", .product(name: "AppleDevelopmentKit", package: "AppleDevelopmentKit")],
            swiftSettings: [.enableUpcomingFeature("ApproachableConcurrency")]
        ),
    ]
)
