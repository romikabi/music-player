import Foundation

extension Result where Failure == Error {
  public init(catching: () async throws -> Success) async {
    do {
      self = .success(try await catching())
    } catch {
      self = .failure(error)
    }
  }
}

extension Result {
  public func map<NewSuccess, NewFailure>(
    _ transform: (Success) async -> Result<NewSuccess, NewFailure>
  ) async -> Result<NewSuccess, Either<Failure, NewFailure>> {
    switch self {
    case let .success(success):
      return await transform(success).mapError(Either.second)
    case let .failure(error):
      return .failure(.first(error))
    }
  }

  public func map<NewSuccess, NewFailure>(
    _ transform: (Success) async throws -> NewSuccess,
    catchingAs mapError: (Error) -> NewFailure
  ) async -> Result<NewSuccess, Either<Failure, NewFailure>> {
    switch self {
    case let .success(success):
      return await Result<NewSuccess, Error> { try await transform(success) }
        .mapError(mapError)
        .mapError(Either.second)
    case let .failure(error):
      return .failure(.first(error))
    }
  }
}
