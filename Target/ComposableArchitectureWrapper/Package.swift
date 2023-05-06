// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "ComposableArchitectureWrapper",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "ComposableArchitectureWrapper",
            targets: ["ComposableArchitectureWrapper"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "0.52.0"),
    ],
    targets: [
        .target(
            name: "ComposableArchitectureWrapper",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "ComposableArchitectureTests",
            dependencies: ["ComposableArchitectureWrapper"]
        ),
    ]
)
