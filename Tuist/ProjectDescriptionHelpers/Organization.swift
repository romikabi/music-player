import ProjectDescription

public struct Organization {
  public var name: String

  public init(name: String) {
    self.name = name
  }

  public func bundleId(name: String) -> String {
    "\(self.name.lowercased()).\(name.lowercased())"
  }
}
