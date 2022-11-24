import ProjectDescription
import ProjectDescriptionHelpers

let name = "music-player"
let organization = Organization(name: "com.romikabi")
let platform = Platform.iOS

// MARK: - Base

let core = Target.make(
  name: "Core",
  platform: platform,
  product: .framework,
  organization: organization
)

let ui = Target.make(
  name: "UI",
  platform: platform,
  product: .framework,
  organization: organization,
  dependencies: [
    .target(name: core.name),
  ]
)

let itunes = Target.make(
  name: "Itunes",
  platform: .iOS,
  product: .framework,
  organization: organization,
  dependencies: [
    .target(name: core.name),
  ]
)

let track = Target.make(
  name: "Track",
  platform: .iOS,
  product: .framework,
  organization: organization,
  dependencies: [
    .target(name: core.name),
  ]
)

// MARK: - Features

let features = [
  Target.make(
    name: "TrackSearch",
    platform: .iOS,
    product: .framework,
    organization: organization,
    dependencies: [
      .target(name: track.name),
      .target(name: core.name),
      .target(name: ui.name),
      .external(product: ComposableArchitecture.ComposableArchitecture),
    ]
  ),

  Target.make(
    name: "DebugOverlay",
    platform: .iOS,
    product: .framework,
    organization: organization,
    dependencies: [
      .target(name: core.name),
      .target(name: ui.name),
      .external(product: ComposableArchitecture.ComposableArchitecture),
    ]
  )
]

// MARK: - App

let app = Target.make(
  name: "App",
  platform: platform,
  product: .app,
  organization: organization,
  infoPlist: .extendingDefault(with: [
    "CFBundleShortVersionString": "1.0",
    "CFBundleVersion": "1",
    "UIMainStoryboardFile": "",
    "UILaunchStoryboardName": "LaunchScreen"
  ]),
  dependencies: [
    .target(name: core.name),
    .target(name: ui.name),
    .target(name: itunes.name),
  ] + features
    .map(\.name)
    .map(TargetDependency.target(name:))
)

// MARK: - Project

let project = Project(
  name: name,
  targets: [
    core,
    ui,
    track,
    itunes,
    app,
  ] + features
)
