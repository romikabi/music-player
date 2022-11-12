// Copyright 2022 Yandex LLC. All rights reserved.

import Foundation

@propertyWrapper
struct Tagged<Tag, Value> {
  let wrappedValue: Value

  var projectedValue: Tagged<Tag, Value> {
    self
  }
}

extension Tagged: Decodable where Value: Decodable {
  init(from decoder: Decoder) throws {
    wrappedValue = try decoder.singleValueContainer().decode(Value.self)
  }
}

extension Tagged: Encodable where Value: Encodable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(wrappedValue)
  }
}

extension Tagged: Comparable where Value: Comparable {
  static func <(lhs: Self, rhs: Self) -> Bool {
    lhs.wrappedValue < rhs.wrappedValue
  }
}

extension Tagged: Equatable where Value: Equatable {}

extension Tagged: Hashable where Value: Hashable {}
