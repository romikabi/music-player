// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Itunes",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Itunes",
            targets: ["Itunes"]
        ),
    ],
    dependencies: [
        .package(path: "../Core"),
    ],
    targets: [
        .target(
            name: "Itunes",
            dependencies: [
                .product(name: "Core", package: "Core"),
            ]
        ),
        .testTarget(
            name: "ItunesTests",
            dependencies: ["Itunes"]),
    ]
)
