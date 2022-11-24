import Foundation
import Core

extension Itunes {
  public enum Search {}

  public static func search(
    params: Search.Params,
    urlSession: URLSession,
    jsonDecoder: JSONDecoder
  ) async -> Result<[Song], Either<URLSessionDataError, JSONDecoderError>> {
    await urlSession
      .result(from: Search.makeURL(params: params))
      .map(\.0)
      .map(jsonDecoder.result(decode: Search.Response.self))
      .map(\.results)
  }
}

extension Itunes.Search {
  public struct Params {
    public var query: String
    public var limit: UInt

    public init(query: String, limit: UInt = 50) {
      self.query = query
      self.limit = limit
    }
  }

  public struct Response: Decodable {
    public let results: [Itunes.Song]
  }

  public enum Error: Swift.Error {
    case urlSession(Swift.Error)
    case jsonDecoding(Swift.Error)
  }

  static func makeURL(params: Params) -> URL {
    URL(string: "https://itunes.apple.com/search")!.appending(queryItems: [
      URLQueryItem(name: "term", value: params.query),
      URLQueryItem(name: "limit", value: "\(params.limit)"),
      URLQueryItem(name: "media", value: "music"),
    ])
  }
}
