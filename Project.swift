import ProjectDescription
import ProjectDescriptionHelpers

let name = "music-player"
let organization = Organization(name: "com.romikabi")
let platform = Platform.iOS

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

let kit = Target.make(
  name: "Kit",
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
    .target(name: kit.name),
    .target(name: core.name),
  ]
)

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
    .target(name: kit.name),
    .target(name: itunes.name),
  ]
)

let project = Project(
  name: name,
  targets: [
    core,
    ui,
    kit,
    app,
    itunes,
  ]
)
