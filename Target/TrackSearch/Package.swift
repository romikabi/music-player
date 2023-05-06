// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "TrackSearch",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "TrackSearch",
            targets: ["TrackSearch"]
        ),
    ],
    dependencies: [
        .package(path: "../Track"),
        .package(path: "../Core"),
        .package(path: "../UI"),
        .package(path: "../ComposableArchitectureWrapper"),
    ],
    targets: [
        .target(
            name: "TrackSearch",
            dependencies: [
                .product(name: "Track", package: "Track"),
                .product(name: "Core", package: "Core"),
                .product(name: "UI", package: "UI"),
                .product(name: "ComposableArchitectureWrapper", package: "ComposableArchitectureWrapper"),
            ]
        ),
        .testTarget(
            name: "TrackSearchTests",
            dependencies: ["TrackSearch"]
        ),
    ]
)
