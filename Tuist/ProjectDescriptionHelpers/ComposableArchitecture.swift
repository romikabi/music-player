import ProjectDescription

// MARK: - Composable Architecture

public enum ComposableArchitecture: String, PackageProduct {
  public static let package = Package.package(
    url: "https://github.com/pointfreeco/swift-composable-architecture",
    from: "0.45"
  )

  case ComposableArchitecture

  public var product: Product {
    switch self {
    case .ComposableArchitecture:
      return .framework
    }
  }
}
