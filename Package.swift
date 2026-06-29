// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FeedKit",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "FeedKit",
            targets: ["FeedKit"]),
    ],
    targets: [
        .target(
            name: "FeedKit"),
        .testTarget(
            name: "FeedKitTests",
            dependencies: ["FeedKit"]),
    ]
)
