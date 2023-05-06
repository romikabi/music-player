import Foundation

public protocol Track: Identifiable, Equatable {
  var name: String { get }
  var artistName: String { get }
  var duration: Duration { get }
  var artworkURL: URL? { get }
}
