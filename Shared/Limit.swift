// Copyright 2022 Yandex LLC. All rights reserved.

import Foundation

@propertyWrapper
struct Limit<Range: RangeExpression> where Range.Bound: FixedWidthInteger {
  init(wrappedValue: Range.Bound, _ range: Range) {
    self.value = wrappedValue
    self.range = range
  }
  
  var wrappedValue: Range.Bound {
    get {
      guard !range.contains(value) else { return value }

      let range = range.relative(to: Range.Bound.min..<Range.Bound.max)

      if value < range.lowerBound {
        return range.lowerBound
      }

      if value > range.upperBound {
        return range.upperBound - 1
      }

      return value
    }
    set {
      value = newValue
    }
  }

  var range: Range

  private var value: Range.Bound
}
