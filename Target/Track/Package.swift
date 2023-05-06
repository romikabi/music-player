// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Track",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Track",
            targets: ["Track"]
        ),
    ],
    dependencies: [
        .package(path: "../Core"),
    ],
    targets: [
        .target(
            name: "Track",
            dependencies: [
                .product(name: "Core", package: "Core"),
            ]
        ),
        .testTarget(
            name: "TrackTests",
            dependencies: ["Track"]),
    ]
)
