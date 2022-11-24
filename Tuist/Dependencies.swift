import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
  swiftPackageManager: .init(
    [
      ComposableArchitecture.package,
    ],
    productTypes: [
      ComposableArchitecture.self
    ].productTypes
  )
)
