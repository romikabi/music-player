import ProjectDescription
import ProjectDescriptionHelpers

let descriptors: [any PackageProduct.Type] = [
  ComposableArchitecture.self
]

let dependencies = Dependencies(
  swiftPackageManager: .init(
    descriptors.packages,
    productTypes: descriptors.productTypes
  )
)
