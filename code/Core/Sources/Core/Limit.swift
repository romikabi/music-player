import Foundation

@propertyWrapper
public struct Limit<Range: RangeExpression> where Range.Bound: FixedWidthInteger {
  public init(wrappedValue: Range.Bound, _ range: Range) {
    self.value = wrappedValue
    self.range = range
  }
  
  public var wrappedValue: Range.Bound {
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

  public var range: Range

  private var value: Range.Bound
}
