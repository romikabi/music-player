// Copyright 2022 Yandex LLC. All rights reserved.

import SwiftUI

func log(_ items: Any...) {
  print(">>>", items)
}

extension Color {
  static var random: Self {
    Self(
      red: .random(in: 0...1),
      green: .random(in: 0...1),
      blue: .random(in: 0...1)
    )
  }
}

extension View {
  @ViewBuilder func visibility(_ enabled: Bool) -> some View {
    if enabled {
      border(Color.random)
    } else {
      self
    }
  }
}

//struct MyHStack: Layout {
//  var alignment = VerticalAlignment.center
//  var spacing = 8 as CGFloat
//
//  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
//    var total = CGSize.zero
//    var x = CGFloat.zero
//
//    for subview in subviews {
//      let size = subview.dimensions(in: proposal)
//
//      x += size.width
//      total.width = x
//      x += spacing
//
//      switch subview[Vertical.self] {
//      case .stretch:
//        total.height = max(size.height, total.height)
//      case .fit, .stay:
//        break
//      }
//    }
//
//    return total
//  }
//
//  func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
//    var x = CGFloat.zero
//
//    let anchor: UnitPoint
//    let y: CGFloat
//    switch alignment {
//    case .center:
//      anchor = .leading
//      y = bounds.midY
//    case .bottom:
//      anchor = .bottomLeading
//      y = bounds.maxY
//    default:
//      anchor = .topLeading
//      y = bounds.minY
//    }
//
//    for subview in subviews {
//      let proposal: ProposedViewSize
//      switch subview[Vertical.self] {
//      case .stretch, .stay:
//        proposal = .unspecified
//      case .fit:
//        proposal = ProposedViewSize(width: nil, height: bounds.height)
//      }
//
//      subview.place(
//        at: CGPoint(x: x, y: y),
//        anchor: anchor,
//        proposal: proposal
//      )
//
//      x += subview.dimensions(in: ProposedViewSize(bounds.size)).width + spacing
//    }
//  }
//
//  enum Vertical: LayoutValueKey {
//    static var defaultValue = Self.stretch
//
//    case stretch
//    case fit
//    case stay
//  }
//}

struct TrackView: View {
  init(
    _ track: any Track,
    formatter: DateComponentsFormatter,
    visibility: Bool
  ) {
    self.track = track
    self.formatter = formatter
    self.visibility = visibility
  }

  var body: some View {
    HStack {
      ZStack {
        if let imageURL = track.artworkURL {
          AsyncImage(url: imageURL) { image in
            image.resizable().scaledToFit()
          } placeholder: {
            imagePlaceholder
          }
        } else {
          imagePlaceholder
        }
      }
      .scaledToFit()
      .frame(idealWidth: 5, idealHeight: 5)
      .cornerRadius(8, antialiased: true)
      .visibility(visibility)

      VStack(alignment: .leading) {
        Text(track.name)
          .font(.headline)
          .lineLimit(1)

        Text(track.artistName)
          .font(.subheadline)
          .lineLimit(1)
      }
      .visibility(visibility)

      Spacer()
      if let duration = formatter.string(from: track.duration.timeInterval) {
        Text(duration)
          .font(.footnote)
          .visibility(visibility)
      }
    }.visibility(visibility)
  }

  private var imagePlaceholder: some View {
    Image(systemName: "music.note").scaledToFit()
  }

  private let track: any Track
  private let formatter: DateComponentsFormatter
  private let visibility: Bool
}

struct SearchList<Entity: Identifiable, RowContent: View>: View {
  init(
    search: @escaping (String) async throws -> [Entity],
    rowContent: @escaping (Entity) -> RowContent
  ) {
    self.search = search
    self.rowContent = rowContent
  }

  var body: some View {
    NavigationView {
      VStack {
        if let errorText = errorText {
          Text(errorText)
            .padding()
        } else {
          List(entities, rowContent: rowContent)
            .navigationTitle("Search")
        }
        Spacer()
      }
    }.searchable(
      text: $searchText,
      prompt: "cueres?"
    ).onChange(of: searchText) { newValue in
      errorText = nil
      Task {
        do {
          entities = try await search(searchText)
        } catch {
          errorText = "\(error)"
        }
      }
    }
  }

  @State
  private var searchText = ""
  @State
  private var entities: [Entity] = []
  @State
  private var errorText: String?

  private let search: (String) async throws -> [Entity]
  private let rowContent: (Entity) -> RowContent
}

struct SearchResult_Previews: PreviewProvider {
  static var previews: some View {
    List {
      TrackView(
        Itunes.Song(
          id: 1,
          name: "Song",
          artistName: "Artist",
          duration: .minutes(3) + .seconds(35),
          artworkURL: URL(string: "https://is5-ssl.mzstatic.com/image/thumb/Music115/v4/60/f8/a6/60f8a6bc-e875-238d-f2f8-f34a6034e6d2/14UMGIM07615.rgb.jpg/100x100bb.jpg")
        ),
        formatter: DateComponentsFormatter(),
        visibility: false
      )

      TrackView(
        Itunes.Song(
          id: 1,
          name: "Song",
          artistName: "Artist",
          duration: .minutes(3) + .seconds(35),
          artworkURL: nil
        ),
        formatter: DateComponentsFormatter(),
        visibility: false
      )
    }.previewLayout(.sizeThatFits)
  }
}

struct SearchList_Previews: PreviewProvider {
  static var previews: some View {
    SearchList(search: Searcher().search) { song in
      TrackView(song, formatter: formatter, visibility: false)
    }
  }

  private static let formatter = DateComponentsFormatter()
}

protocol Track: Identifiable {
  var name: String { get }
  var artistName: String { get }
  var duration: Time { get }
  var artworkURL: URL? { get }
}

enum Itunes {}

extension Itunes {
  struct Song: Decodable, Track {
    @Tagged<Song, UInt64>
    var id: UInt64
    var name: String
    var artistName: String
    @Time.Milliseconds
    var duration: Time
    var artworkURL: URL?

    private enum CodingKeys: String, CodingKey {
      case id = "trackId"
      case artistName
      case name = "trackName"
      case duration = "trackTimeMillis"
      case artworkURL = "artworkUrl100"
    }
  }
}

extension Itunes {
  enum Search {}
}

extension Itunes.Search {
  struct Response: Decodable {
    let results: [Itunes.Song]
  }
}

struct Searcher {
  func search(_ query: String) async throws -> [Itunes.Song] {
    let (data, _) = try await session.data(from: URL(
      string: "https://itunes.apple.com/search?term=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&media=music&limit=50"
    )!)
    return try JSONDecoder().decode(Itunes.Search.Response.self, from: data).results
  }

  private let session = URLSession(configuration: .ephemeral)
}

extension URLSession.AsyncBytes {
  func collect(total: Int, progress: inout Double?) async throws -> Data {
    log("total", total)
    var data = Data()
    data.reserveCapacity(total)

    var done = 0
    for try await byte in self {
      data.append(byte)
      let newDone = data.count / total

      if newDone != done {
        done = newDone
        progress = Double(done) / Double(total)
      }
    }

    return data
  }
}
