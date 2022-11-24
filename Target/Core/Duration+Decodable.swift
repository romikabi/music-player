import Foundation

// MARK: - DecodableAsMilliseconds

extension Duration {
  @propertyWrapper
  public struct DecodableAsMilliseconds: Equatable, Hashable, Decodable {
    public var wrappedValue: Duration

    public init(wrappedValue: Duration) {
      self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
      wrappedValue = .milliseconds(
        try decoder
          .singleValueContainer()
          .decode(Int.self)
      )
    }
  }
}

// MARK: - DecodableAsSeconds

extension Duration {
  @propertyWrapper
  public struct DecodableAsSeconds: Equatable, Hashable, Decodable {
    public var wrappedValue: Duration

    public init(wrappedValue: Duration) {
      self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
      wrappedValue = .seconds(
        try decoder
          .singleValueContainer()
          .decode(Int.self)
      )
    }
  }
}
