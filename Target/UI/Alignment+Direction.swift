import SwiftUI
import Core

extension Alignment {
  public func moving(to direction: Direction2D) -> Alignment {
    Alignment(
      horizontal: horizontal.moving(to: direction.horizontal),
      vertical: vertical.moving(to: direction.vertical)
    )
  }

  public mutating func move(to direction: Direction2D) {
    self = moving(to: direction)
  }
}

extension HorizontalAlignment {
  public func moving(to direction: Direction1D?) -> HorizontalAlignment {
    guard let direction else { return self }
    switch (self, direction) {
    case (.trailing, .leading),
      (.leading, .trailing):
      return .center
    case (_, .leading):
      return .leading
    case (_, .trailing):
      return .trailing
    }
  }
}

extension VerticalAlignment {
  public func moving(to direction: Direction1D?) -> VerticalAlignment {
    guard let direction else { return self }
    switch (self, direction) {
    case (.bottom, .leading),
      (.top, .trailing):
      return .center
    case (_, .leading):
      return .top
    case (_, .trailing):
      return .bottom
    }
  }
}
