// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "PixelUI",
    platforms: [
        .iOS(.v14),
        .tvOS(.v14),
        .macOS(.v11),
    ],
    products: [
        .library(
            name: "PixelUI",
            targets: ["PixelUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/heestand-xyz/PixelKit", from: "2.1.2"),
        .package(url: "https://github.com/heestand-xyz/PixelColor", from: "1.3.0"),
        .package(url: "https://github.com/heestand-xyz/Resolution", from: "1.0.3"),
        .package(url: "https://github.com/heestand-xyz/MultiViews", from: "1.4.1"),
        .package(url: "https://github.com/heestand-xyz/CoreGraphicsExtensions", from: "1.2.0"),
        .package(url: "https://github.com/heestand-xyz/Logger", from: "0.2.0"),
    ],
    targets: [
        .target(
            name: "PixelUI",
            dependencies: ["PixelKit", "PixelColor", "Resolution", "Logger", "CoreGraphicsExtensions", "MultiViews"]),
        .testTarget(
            name: "PixelUITests",
            dependencies: ["PixelUI"]),
    ]
)
