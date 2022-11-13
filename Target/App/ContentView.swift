// Copyright 2022 Yandex LLC. All rights reserved.

import SwiftUI
import Core
import Kit
import Itunes
import UI

struct SearchList<Entity: Identifiable, RowContent: View>: View {
  init(
    search: @escaping (String) async -> Either<[Entity], String>,
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
      }
    }.searchable(
      text: $searchText,
      prompt: "cueres?"
    ).onChange(of: searchText) { newValue in
      errorText = nil
      Task {
        switch await search(searchText) {
        case let .first(result):
          entities = result
        case let .second(error):
          errorText = error
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

  private let search: (String) async -> Either<[Entity], String>
  private let rowContent: (Entity) -> RowContent
}


func makeItunesSongSearchList<RowContent: View>(
  rowContent: @escaping (Itunes.Song) -> RowContent
) -> SearchList<Itunes.Song, RowContent> {
  SearchList(
    search: { query in
      switch await Itunes.search(params: .init(query: query)) {
      case let .success(songs):
        return .first(songs)
      case let .failure(.second(jsonError)):
        return .second("\(jsonError.error)\n\n\(jsonError.json ?? "no json")")
      case let .failure(.first(urlError)):
        return .second("\(urlError)")
      }
    },
    rowContent: rowContent
  )
}

struct SearchResult_Previews: PreviewProvider {
  static var previews: some View {
    List {
      TrackView(
        name: "Song",
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
    }.previewLayout(.sizeThatFits)
  }
}

struct SearchList_Previews: PreviewProvider {
  static var previews: some View {
    makeItunesSongSearchList { song in
      TrackView(
        name: song.name,
        artistName: song.artistName,
        duration: song.duration,
        artworkURL: song.artworkURL,
        formatter: formatter,
        visibility: false
      )
    }
  }

  private static let formatter = DateComponentsFormatter()
}

extension URLSession.AsyncBytes {
  func collect(total: Int, progress: inout Double?) async throws -> Data {
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
