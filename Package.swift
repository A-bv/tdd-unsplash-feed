// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "UnsplashFeed",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(name: "UnsplashFeed", targets: ["UnsplashFeed"]),
    ],
    targets: [
        .target(name: "UnsplashFeed"),
        .testTarget(name: "UnsplashFeedTests", dependencies: ["UnsplashFeed"]),
    ]
)
