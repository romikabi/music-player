import Foundation

public enum Either<T1, T2> {
  case first(T1)
  case second(T2)
}

extension Either: Error where T1: Error, T2: Error {}
