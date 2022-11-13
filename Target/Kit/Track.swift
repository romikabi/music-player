import Foundation
import Core

public protocol Track: Identifiable {
  var name: String { get }
  var artistName: String { get }
  var duration: Time { get }
  var artworkURL: URL? { get }
}
