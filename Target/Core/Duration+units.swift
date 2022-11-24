import Foundation

extension Duration {
  public static func minutes<T: BinaryInteger>(_ minutes: T) -> Duration {
    .seconds(minutes * 60)
  }

  public static func hours<T: BinaryInteger>(_ hours: T) -> Duration {
    .minutes(hours * 60)
  }

  public var timeInterval: TimeInterval {
    Double(components.seconds)
  }
}
