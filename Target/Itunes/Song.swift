import Foundation
import Core
import Kit

extension Itunes {
  public struct Song: Decodable, Track {
    @Tagged<Self, UInt64>
    public var id: UInt64

    public var name: String

    public var artistName: String

    @Time.Milliseconds
    public var duration: Time

    public var artworkURL: URL?

    public init(id: UInt64, name: String, artistName: String, duration: Time, artworkURL: URL? = nil) {
      self.id = id
      self.name = name
      self.artistName = artistName
      self.duration = duration
      self.artworkURL = artworkURL
    }

    private enum CodingKeys: String, CodingKey {
      case id = "trackId"
      case artistName
      case name = "trackName"
      case duration = "trackTimeMillis"
      case artworkURL = "artworkUrl100"
    }
  }
}
