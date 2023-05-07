import SwiftUI
import Itunes
import ComposableArchitecture
import Track
import TrackSearch
import DebugOverlay

struct AppReducer<TrackSearchCollection: RandomAccessCollection & Equatable & ExpressibleByArrayLiteral>: ReducerProtocol where TrackSearchCollection.Element: Track {
  struct State {
    var debugOverlay = DebugOverlay.State()
    var trackSearch = TrackSearch<TrackSearchCollection>.State()
  }

  enum Action {
    case trackSearch(TrackSearch<TrackSearchCollection>.Action)
    case debugOverlay(DebugOverlay.Action)
  }

  let searchTracks: TrackSearch<TrackSearchCollection>.SearchTracks

  var body: some ReducerProtocol<State, Action> {
    Scope(state: \.trackSearch, action: /Action.trackSearch) {
      TrackSearch(searchTracks: searchTracks)
    }
    Scope(state: \.debugOverlay, action: /Action.debugOverlay) {
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
    reducer: Reducer(searchTracks: Itunes.searchTracks)
  )

  public var body: some Scene {
    WindowGroup {
      ZStack {
        TrackSearchView(
          store: store.scope(
            state: \.trackSearch,
            action: Reducer.Action.trackSearch
          )
        )
        DebugOverlayView(
          store: store.scope(
            state: \.debugOverlay,
            action: Reducer.Action.debugOverlay
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
