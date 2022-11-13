import Foundation

@propertyWrapper
public struct Tagged<Tag, Value> {
  public var wrappedValue: Value

  public init(wrappedValue: Value) {
    self.wrappedValue = wrappedValue
  }

  public var projectedValue: Tagged<Tag, Value> {
    self
  }
}

extension Tagged: Decodable where Value: Decodable {
  public init(from decoder: Decoder) throws {
    wrappedValue = try decoder.singleValueContainer().decode(Value.self)
  }
}

extension Tagged: Encodable where Value: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(wrappedValue)
  }
}

extension Tagged: Comparable where Value: Comparable {
  public static func <(lhs: Self, rhs: Self) -> Bool {
    lhs.wrappedValue < rhs.wrappedValue
  }
}

extension Tagged: Equatable where Value: Equatable {}

extension Tagged: Hashable where Value: Hashable {}
