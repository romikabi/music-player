// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Core",
            targets: ["Core"]),
    ],
    targets: [
        .target(
            name: "Core"),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"]),
    ]
)
