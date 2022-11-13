import ProjectDescription

extension Target {
  public static func make(
    name: String,
    platform: Platform,
    product: Product,
    organization: Organization,
    infoPlist: InfoPlist? = .default,
    dependencies: [TargetDependency] = []
  ) -> Target {
    Target(
      name: name,
      platform: platform,
      product: product,
      bundleId: organization.bundleId(name: name),
      infoPlist: infoPlist,
      sources: ["Target/\(name)/**"],
      dependencies: dependencies
    )
  }
}
