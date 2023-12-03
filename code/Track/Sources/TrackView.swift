import SwiftUI
import Core

public struct TrackView: View {
  public init(
    name: String,
    artistName: String,
    duration: Duration,
    artworkURL: URL?
  ) {
    self.name = name
    self.artistName = artistName
    self.duration = duration
    self.artworkURL = artworkURL
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
                .cornerRadius(4)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .aspectRatio(1, contentMode: .fit)
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
      .frame(idealHeight: 0)

      VStack(alignment: .leading) {
        Text(name)
          .font(.headline)
          .lineLimit(1)

        Text(artistName)
          .font(.subheadline)
          .lineLimit(1)
      }

      Spacer()

      Text(duration.formatted(.time(pattern: .minuteSecond(padMinuteToLength: 2))))
        .font(.footnote)
    }
    .fixedSize(horizontal: false, vertical: true)
  }

  private var note: some View {
    Image(systemName: "music.note")
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .aspectRatio(1, contentMode: .fit)
  }

  private let name: String
  private let artistName: String
  private let duration: Duration
  private let artworkURL: URL?

  @State
  private var imageLoaded = false
}


struct Preview: PreviewProvider {
  static var previews: some View {
    List {
      TrackView(
        name: "Song Song Song Song Song Song Song Song Song",
        artistName: "Artist",
        duration: .minutes(3) + .seconds(35),
        artworkURL: URL(string: "https://is5-ssl.mzstatic.com/image/thumb/Music115/v4/60/f8/a6/60f8a6bc-e875-238d-f2f8-f34a6034e6d2/14UMGIM07615.rgb.jpg/100x100bb.jpg")
      )

      TrackView(
        name: "Song",
        artistName: "Artist",
        duration: .hours(1) + .minutes(3) + .seconds(35),
        artworkURL: URL(string: "https://is4-ssl.mzstatic.com/image/thumb/Video128/v4/8c/99/0a/8c990acc-2d0e-33b3-0280-687907808e8d/Warner.185732005.093624444664_USWBV0600456.CROPPED.dj.ghxywlgv.jpg/100x100bb.jpg")
      )

      TrackView(
        name: "Song",
        artistName: "Artist",
        duration: .seconds(35),
        artworkURL: nil
      )
    }
  }
}
