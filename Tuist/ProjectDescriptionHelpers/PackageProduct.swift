import ProjectDescription

public protocol PackageProduct: CaseIterable {
  static var package: Package { get }

  var name: String { get }
  var product: Product { get }
}

extension PackageProduct where Self: RawRepresentable, Self.RawValue == String {
  public var name: String {
    rawValue
  }
}

extension TargetDependency {
  public static func package<PD: PackageProduct & RawRepresentable>(
    product: PD
  ) -> TargetDependency where PD.RawValue == String {
    .external(name: product.rawValue)
  }
}

extension PackageProduct {
  public static var productTypes: [String: Product] {
    Dictionary(uniqueKeysWithValues: Self.allCases.map { ($0.name, $0.product) })
  }
}

extension Sequence where Element == any PackageProduct.Type {
  public var packages: [Package] {
    map { $0.package }
  }

  public var productTypes: [String: Product] {
    reduce(into: [:]) { partialResult, element in
      partialResult.merge(element.productTypes, uniquingKeysWith: { f, s in s })
    }
  }
}
