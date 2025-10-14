// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CircularContextMenu",

    // Supported platforms
    platforms: [
        .iOS(.v16)
    ],

    // Library products
    products: [
        .library(
            name: "CircularContextMenu",
            targets: ["CircularContextMenu"]
        )
    ],

    // External dependencies (none currently)
    dependencies: [],

    // Build targets
    targets: [
        .target(
            name: "CircularContextMenu",
            dependencies: [],
            path: "Sources/CircularContextMenu",
            exclude: [],
            resources: [],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        )
    ],

    // Swift language version
    swiftLanguageVersions: [.v5]
)
