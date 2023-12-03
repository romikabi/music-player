import Foundation

public struct JSONDecoderError: Error {
  public var error: Error
  public var json: String?
}

extension JSONDecoder {
  public func result<T: Decodable>(decode type: T.Type) -> (Data) async -> Result<T, JSONDecoderError> {
    { await self.result(decode: type, from: $0) }
  }

  public func result<T: Decodable>() -> (Data) async -> Result<T, JSONDecoderError> {
    { await self.result(decode: T.self, from: $0) }
  }

  public func result<T: Decodable>(decode type: T.Type, from data: Data) async -> Result<T, JSONDecoderError> {
    await Task {
      result(decode: type, from: data)
    }.value
  }

  public func result<T: Decodable>(from data: Data) async -> Result<T, JSONDecoderError> {
    await result(decode: T.self, from: data)
  }

  private func result<T: Decodable>(
    decode type: T.Type,
    from data: Data
  ) -> Result<T, JSONDecoderError> {
    Result {
      try decode(type, from: data)
    }.mapError { error in
      JSONDecoderError(
        error: error,
        json: (try? JSONSerialization.jsonObject(with: data))
          .flatMap { try? JSONSerialization.data(withJSONObject: $0, options: .prettyPrinted) }
          .flatMap { String(data: $0, encoding: .utf8) }
      )
    }
  }
}
