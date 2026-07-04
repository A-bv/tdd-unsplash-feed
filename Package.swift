// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FeedKit",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "FeedKit",
            targets: ["FeedKit"]),
    ],
    targets: [
        .target(name: "FeedKit"),
        .testTarget(
            name: "FeedKitTests",
            dependencies: ["FeedKit"]),
    ]
)
