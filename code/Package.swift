// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "App",
    platforms: [.iOS(.v17), .macOS(.v13)],
    products: [
        .library(
            name: "App",
            targets: ["App"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            branch: "observation-beta")
    ],
    targets: [
        module(name: "Core"),
        module(name: "UI", dependencies: ["Core"]),
        module(name: "Track", dependencies: ["Core"]),
        module(name: "Music", dependencies: ["Core"]),
        module(name: "Itunes", dependencies: ["Core"]),
        module(name: "DebugOverlay", dependencies: [
            "Core",
            "UI",
            .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        ]),
        module(name: "TrackSearch", dependencies: [
            "Track",
            "Core",
            "UI",
            .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        ]),
        module(
            name: "App",
            dependencies: [
                "Itunes",
                "Core",
                "UI",
                "TrackSearch",
                "DebugOverlay",
            ]
        ),
    ].flatMap { $0 }
)

fileprivate func module(
    name: String,
    dependencies: [Target.Dependency] = []
) -> [Target] {
    [
        .target(
            name: name,
            dependencies: dependencies,
            path: "\(name)/Sources"
        ),
        .testTarget(
            name: "\(name)Tests",
            dependencies: [.target(name: name)],
            path: "\(name)/Tests/"
        ),
    ]
}
