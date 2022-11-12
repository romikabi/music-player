// Copyright 2022 Yandex LLC. All rights reserved.

import Foundation

struct Time: Equatable, Hashable, Codable {
  var microseconds: Int
}

extension Time: Comparable {
  static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.microseconds < rhs.microseconds
  }
}

extension Time: AdditiveArithmetic {
  static let zero = Self(microseconds: 0)
  
  static func + (lhs: Self, rhs: Self) -> Self {
    Self(microseconds: lhs.microseconds + rhs.microseconds)
  }

  static func - (lhs: Time, rhs: Time) -> Time {
    Self(microseconds: lhs.microseconds - rhs.microseconds)
  }
}

// MARK: - Milliseconds

extension Time {
  static func milliseconds(_ value: Int) -> Time {
    self.init(value, unit: .millisecond)
  }

  var milliseconds: Int {
    get { get(.millisecond) }
    set { self = Time(newValue, unit: .millisecond) }
  }

  @propertyWrapper
  struct Milliseconds {
    var wrappedValue: Time
  }
}

// MARK: - Seconds

extension Time {
  static func seconds(_ value: Int) -> Time {
    self.init(value, unit: .second)
  }

  var seconds: Int {
    get { get(.second) }
    set { self = Time(newValue, unit: .second) }
  }

  @propertyWrapper
  struct Seconds {
    var wrappedValue: Time
  }
}

// MARK: - Minutes

extension Time {
  static func minutes(_ value: Int) -> Time {
    self.init(value, unit: .minute)
  }

  var minutes: Int {
    get { get(.minute) }
    set { self = Time(newValue, unit: .minute) }
  }

  @propertyWrapper
  struct Minutes {
    var wrappedValue: Time
  }
}

// MARK: - Hours

extension Time {
  static func hours(_ value: Int) -> Time {
    self.init(value, unit: .hour)
  }

  var hours: Int {
    get { get(.hour) }
    set { self = Time(newValue, unit: .hour) }
  }

  @propertyWrapper
  struct Hours {
    var wrappedValue: Time
  }
}

// MARK: - TimeInterval

extension Time {
  static func timeInterval(_ value: Foundation.TimeInterval) -> Time {
    Time(microseconds: Int(value * Double(Unit.second.rawValue)))
  }

  var timeInterval: Foundation.TimeInterval {
    get { Double(get(.second)) }
    set { self = .timeInterval(newValue) }
  }

  @propertyWrapper
  struct TimeInterval: Codable {
    var wrappedValue: Time

    init(from decoder: Decoder) throws {
      wrappedValue = .timeInterval(
        try decoder
          .singleValueContainer()
          .decode(Double.self)
      )
    }

    func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()
      try container.encode(wrappedValue.timeInterval)
    }
  }
}

// MARK: Codable

extension Time.Milliseconds: Codable {
  init(from decoder: Decoder) throws {
    wrappedValue = .milliseconds(
      try decoder
        .singleValueContainer()
        .decode(Int.self)
    )
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(wrappedValue.milliseconds)
  }
}

extension Time.Seconds: Codable {
  init(from decoder: Decoder) throws {
    wrappedValue = .seconds(
      try decoder
        .singleValueContainer()
        .decode(Int.self)
    )
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(wrappedValue.seconds)
  }
}

extension Time.Minutes: Codable {
  init(from decoder: Decoder) throws {
    wrappedValue = .minutes(
      try decoder
        .singleValueContainer()
        .decode(Int.self)
    )
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(wrappedValue.minutes)
  }
}

extension Time.Hours: Codable {
  init(from decoder: Decoder) throws {
    wrappedValue = .hours(
      try decoder
        .singleValueContainer()
        .decode(Int.self)
    )
  }

  func encode(to encoder: Encoder) throws {
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
