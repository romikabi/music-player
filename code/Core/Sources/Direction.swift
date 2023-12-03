import Foundation

public enum Direction1D: Equatable {
  case leading
  case trailing
}

public enum Direction2D: Equatable {
  case left
  case upLeft
  case up
  case upRight
  case right
  case downRight
  case down
  case downLeft

  public var horizontal: Direction1D? {
    switch self {
    case .left, .upLeft, .downLeft:
      return .leading
    case .right, .upRight, .downRight:
      return .trailing
    case .up, .down:
      return nil
    }
  }

  public var vertical: Direction1D? {
    switch self {
    case .up, .upLeft, .upRight:
      return .leading
    case .down, .downLeft, .downRight:
      return .trailing
    case .left, .right:
      return nil
    }
  }

  public init?(horizontal: Direction1D? = nil, vertical: Direction1D? = nil) {
    switch (vertical, horizontal) {
    case (nil, .leading): self = .left
    case (.leading, .leading): self = .upLeft
    case (.leading, nil): self = .up
    case (.leading, .trailing): self = .upRight
    case (nil, .trailing): self = .right
    case (.trailing, .trailing): self = .downRight
    case (.trailing, nil): self = .down
    case (.trailing, .leading): self = .downLeft
    case (nil, nil): return nil
    }
  }
}
