import SwiftUI
import Core

public struct TrackView: View {
  public init(
    name: String,
    artistName: String,
    duration: Time,
    artworkURL: URL?,
    formatter: DateComponentsFormatter,
    visibility: Bool
  ) {
    self.name = name
    self.artistName = artistName
    self.duration = duration
    self.artworkURL = artworkURL
    self.formatter = formatter
    self.visibility = visibility
  }

  public var body: some View {
    HStack {
      Group {
        if let imageURL = artworkURL {
          AsyncImage(
            url: imageURL,
            transaction: Transaction(animation: .default)
          ) { phase in
            switch phase {
            case let .success(image):
              image
                .resizable()
                .scaledToFit()
                .cornerRadius(8)
                .shadow(radius: 4)
            case .empty, .failure:
              note
            @unknown default:
              note
            }
          }
        } else {
          note
        }
      }
      .visibility(visibility)
      .frame(idealHeight: 0)

      VStack(alignment: .leading) {
        Text(name)
          .font(.headline)
          .lineLimit(1)

        Text(artistName)
          .font(.subheadline)
          .lineLimit(1)
      }
      .visibility(visibility)

      Spacer()

      if let duration = formatter.string(from: duration.timeInterval) {
        Text(duration)
          .font(.footnote)
          .visibility(visibility)
      }
    }
    .fixedSize(horizontal: false, vertical: true)
    .visibility(visibility)
  }

  private var note: some View {
    Image(systemName: "music.note")
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .aspectRatio(1, contentMode: .fit)
  }

  private let name: String
  private let artistName: String
  private let duration: Time
  private let artworkURL: URL?

  @State
  private var imageLoaded = false
  private let formatter: DateComponentsFormatter
  private let visibility: Bool
}


struct Preview: PreviewProvider {
  static var previews: some View {
    List {
      TrackView(
        name: "Song Song Song Song Song Song Song Song Song",
        artistName: "Artist",
        duration: .minutes(3) + .seconds(35),
        artworkURL: URL(string: "https://is5-ssl.mzstatic.com/image/thumb/Music115/v4/60/f8/a6/60f8a6bc-e875-238d-f2f8-f34a6034e6d2/14UMGIM07615.rgb.jpg/100x100bb.jpg"),
        formatter: DateComponentsFormatter(),
        visibility: false
      )

      TrackView(
        name: "Song",
        artistName: "Artist",
        duration: .minutes(3) + .seconds(35),
        artworkURL: nil,
        formatter: DateComponentsFormatter(),
        visibility: false
      )
    }
    .previewLayout(.sizeThatFits)
  }
}
