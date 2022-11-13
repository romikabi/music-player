import Foundation

public struct Time: Equatable, Hashable, Codable {
  public var microseconds: Int
}

extension Time: Comparable {
  public static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.microseconds < rhs.microseconds
  }
}

extension Time: AdditiveArithmetic {
  public static let zero = Self(microseconds: 0)
  
  public static func + (lhs: Self, rhs: Self) -> Self {
    Self(microseconds: lhs.microseconds + rhs.microseconds)
  }

  public static func - (lhs: Time, rhs: Time) -> Time {
    Self(microseconds: lhs.microseconds - rhs.microseconds)
  }
}

// MARK: - Milliseconds

extension Time {
  public static func milliseconds(_ value: Int) -> Time {
    self.init(value, unit: .millisecond)
  }

  public var milliseconds: Int {
    get { get(.millisecond) }
    set { self = Time(newValue, unit: .millisecond) }
  }

  @propertyWrapper
  public struct Milliseconds {
    public var wrappedValue: Time

    public init(wrappedValue: Time) {
      self.wrappedValue = wrappedValue
    }
  }
}

// MARK: - Seconds

extension Time {
  public static func seconds(_ value: Int) -> Time {
    self.init(value, unit: .second)
  }

  public var seconds: Int {
    get { get(.second) }
    set { self = Time(newValue, unit: .second) }
  }

  @propertyWrapper
  public struct Seconds {
    public var wrappedValue: Time

    public init(wrappedValue: Time) {
      self.wrappedValue = wrappedValue
    }
  }
}

// MARK: - Minutes

extension Time {
  public static func minutes(_ value: Int) -> Time {
    self.init(value, unit: .minute)
  }

  public var minutes: Int {
    get { get(.minute) }
    set { self = Time(newValue, unit: .minute) }
  }

  @propertyWrapper
  public struct Minutes {
    public var wrappedValue: Time

    public init(wrappedValue: Time) {
      self.wrappedValue = wrappedValue
    }
  }
}

// MARK: - Hours

extension Time {
  public static func hours(_ value: Int) -> Time {
    self.init(value, unit: .hour)
  }

  public var hours: Int {
    get { get(.hour) }
    set { self = Time(newValue, unit: .hour) }
  }

  @propertyWrapper
  public struct Hours {
    public var wrappedValue: Time

    public init(wrappedValue: Time) {
      self.wrappedValue = wrappedValue
    }
  }
}

// MARK: - TimeInterval

extension Time {
  public static func timeInterval(_ value: Foundation.TimeInterval) -> Time {
    Time(microseconds: Int(value * Double(Unit.second.rawValue)))
  }

  public var timeInterval: Foundation.TimeInterval {
    get { Double(get(.second)) }
    set { self = .timeInterval(newValue) }
  }

  @propertyWrapper
  public struct TimeInterval: Codable {
    public var wrappedValue: Time

    public init(from decoder: Decoder) throws {
      wrappedValue = .timeInterval(
        try decoder
          .singleValueContainer()
          .decode(Double.self)
      )
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()
      try container.encode(wrappedValue.timeInterval)
    }
  }
}

// MARK: Codable

extension Time.Milliseconds: Codable {
  public init(from decoder: Decoder) throws {
    wrappedValue = .milliseconds(
      try decoder
        .singleValueContainer()
        .decode(Int.self)
    )
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(wrappedValue.milliseconds)
  }
}

extension Time.Seconds: Codable {
  public init(from decoder: Decoder) throws {
    wrappedValue = .seconds(
      try decoder
        .singleValueContainer()
        .decode(Int.self)
    )
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(wrappedValue.seconds)
  }
}

extension Time.Minutes: Codable {
  public init(from decoder: Decoder) throws {
    wrappedValue = .minutes(
      try decoder
        .singleValueContainer()
        .decode(Int.self)
    )
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(wrappedValue.minutes)
  }
}

extension Time.Hours: Codable {
  public init(from decoder: Decoder) throws {
    wrappedValue = .hours(
      try decoder
        .singleValueContainer()
        .decode(Int.self)
    )
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(wrappedValue.hours)
  }
}

// MARK: - Private

private enum Unit: Int {
  case millisecond = 1_000
  case second = 1_000_000
  case minute = 60_000_000
  case hour = 3_600_000_000
}

private extension Time {
  init(_ amount: Int, unit: Unit) {
    microseconds = amount * unit.rawValue
  }

  func get(_ unit: Unit) -> Int {
    microseconds / unit.rawValue
  }
}
