// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FeedKit",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(name: "FeedKit", targets: ["FeedKit"]),
    ],
    targets: [
        .target(name: "FeedKit"),
    ]
)
