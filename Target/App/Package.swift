// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "App",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "App",
            targets: ["App"]
        ),
    ],
    dependencies: [
        .package(path: "../Itunes"),
        .package(path: "../Core"),
        .package(path: "../UI"),
        .package(path: "../ComposableArchitectureWrapper"),
        .package(path: "../TrackSearch"),
        .package(path: "../DebugOverlay"),
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Itunes", package: "Itunes"),
                .product(name: "Core", package: "Core"),
                .product(name: "UI", package: "UI"),
                .product(name: "ComposableArchitectureWrapper", package: "ComposableArchitectureWrapper"),
                .product(name: "TrackSearch", package: "TrackSearch"),
                .product(name: "DebugOverlay", package: "DebugOverlay"),
            ]
        ),
        .testTarget(
            name: "AppTests",
            dependencies: ["App"]),
    ]
)
