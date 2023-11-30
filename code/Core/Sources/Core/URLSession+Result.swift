import Foundation

public struct URLSessionDataError: Error {
  public var error: Error

  public init(error: Error) {
    self.error = error
  }
}

extension URLSession {
  public func result(
    from url: URL,
    delegate: URLSessionTaskDelegate? = nil
  ) async -> Result<(Data, URLResponse), URLSessionDataError> {
    await Result { try await data(from: url, delegate: delegate) }
      .mapError(URLSessionDataError.init)
  }
}
