import SwiftUI
import Itunes
import ComposableArchitecture
import Track
import TrackSearch
import DebugOverlay

@Reducer
struct AppReducer<TrackSearchCollection: RandomAccessCollection & Equatable & ExpressibleByArrayLiteral> where TrackSearchCollection.Element: Track {
    struct State {
        var debugOverlay = DebugOverlay.State()
        var trackSearch = TrackSearch<TrackSearchCollection>.State()
    }

    @CasePathable
    enum Action {
        case trackSearch(TrackSearch<TrackSearchCollection>.Action)
        case debugOverlay(DebugOverlay.Action)
    }

    let searchTracks: TrackSearch<TrackSearchCollection>.SearchTracks

    var body: some Reducer<State, Action> {
        Scope(state: \.trackSearch, action: \.trackSearch) {
            TrackSearch(searchTracks: searchTracks)
        }
        Scope(state: \.debugOverlay, action: \.debugOverlay) {
            DebugOverlay()
        }
    }
}

@main
public struct MusicPlayerApp: App {
    public init() {}

    typealias Reducer = AppReducer<Array<Itunes.Song>>

    let store = Store(
        initialState: .init(),
        reducer: {
            Reducer(searchTracks: Itunes.searchTracks)
        }
    )

    public var body: some Scene {
        WindowGroup {
            ZStack {
                TrackSearchView(
                    store: store.scope(
                        state: \.trackSearch,
                        action: \.trackSearch
                    )
                )
                DebugOverlayView(
                    store: store.scope(
                        state: \.debugOverlay,
                        action: \.debugOverlay
                    )
                )
                .background(.clear)
            }
        }
    }
}

extension Itunes.Song: Track {}

extension Itunes {
    static var searchTracks: TrackSearch<Array<Itunes.Song>>.SearchTracks {{ query, urlSession, jsonDecoder in
        switch await search(
            params: Search.Params(query: query),
            urlSession: urlSession,
            jsonDecoder: jsonDecoder
        ) {
        case let .success(songs):
            return .success(songs)
        case let .failure(.first(urlSessionError)):
            return .failure(.init(
                kind: .urlSessionError,
                errorDescription: urlSessionError.error.localizedDescription
            ))
        case let .failure(.second(jsonError)):
            return .failure(.init(
                kind: .jsonError(json: jsonError.json),
                errorDescription: jsonError.error.localizedDescription
            ))
        }
    }}
}
