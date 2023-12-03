import SwiftUI
import Track
import ComposableArchitecture

public struct TrackSearchView<Collection: RandomAccessCollection & Equatable & ExpressibleByArrayLiteral>: View where Collection.Element: Track {
    @State private var store: StoreOf<TrackSearch<Collection>>

    public init(store: StoreOf<TrackSearch<Collection>>) {
        self.store = store
    }

    public var body: some View {
        NavigationView {
            VStack {
                if let error = store.error {
                    VStack {
                        Text(error.localizedDescription)
                        switch error.kind {
                        case .jsonError(let json):
                            if let json {
                                Text(json)
                            }
                        case .urlSessionError:
                            EmptyView()
                        }
                    }
                }
                List(store.tracks) { track in
                    TrackView(
                        name: track.name,
                        artistName: track.artistName,
                        duration: track.duration,
                        artworkURL: track.artworkURL
                    )
                }
                .navigationTitle("Search")
            }
        }.searchable(
            text: $store.query.sending(\.queryChanged),
            prompt: "cueres?"
        )
    }
}

struct SearchTracksView_Preview: PreviewProvider {
    static var previews: some View {
        TrackSearchView(store: .init(initialState: .init(), reducer: {
            TrackSearch(searchTracks: { query, urlSession, jsonDecoder in
                    .success(
                        !query.isEmpty
                        ? (0...10).map { index in
                            DummyTrack(
                                name: "\(query) \(index)",
                                artistName: "Artist \(index)",
                                duration: .minutes(3) + .seconds(index),
                                artworkURL: nil,
                                id: index
                            )
                        }
                        : []
                    )
            })
        }))
    }
}

private struct DummyTrack: Track {
    var name: String
    var artistName: String
    var duration: Duration
    var artworkURL: URL?
    var id: Int
}
