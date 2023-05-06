// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "DebugOverlay",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "DebugOverlay",
            targets: ["DebugOverlay"]
        ),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../UI"),
        .package(path: "../ComposableArchitectureWrapper"),
    ],
    targets: [
        .target(
            name: "DebugOverlay",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "UI", package: "UI"),
                .product(name: "ComposableArchitectureWrapper", package: "ComposableArchitectureWrapper"),
            ]
        ),
        .testTarget(
            name: "DebugOverlayTests",
            dependencies: ["DebugOverlay"]),
    ]
)
