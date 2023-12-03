import Foundation
import ComposableArchitecture
import Track

@Reducer
public struct TrackSearch<Collection: RandomAccessCollection & Equatable & ExpressibleByArrayLiteral> where Collection.Element: Track {
    public typealias Result = Swift.Result<Collection, Error>
    public typealias SearchTracks = (
        _ query: String,
        _ urlSession: URLSession,
        _ jsonDecoder: JSONDecoder
    ) async -> Result

    public var searchTracks: SearchTracks
    @Dependency(\.uuid) var uuid
    @Dependency(\.urlSession) var urlSession
    @Dependency(\.mainQueue) var mainQueue

    public init(searchTracks: @escaping SearchTracks) {
        self.searchTracks = searchTracks
    }

    public struct Error: LocalizedError, Equatable {
        public enum Kind: Equatable {
            case jsonError(json: String?)
            case urlSessionError
        }

        public var kind: Kind
        public var errorDescription: String?

        public init(kind: Kind, errorDescription: String? = nil) {
            self.kind = kind
            self.errorDescription = errorDescription
        }
    }

    @ObservableState
    public struct State: Equatable {
        public var query: String
        public var result: Result?

        public init(query: String = "", result: Result? = nil) {
            self.query = query
            self.result = result
        }

        var tracks: Collection {
            (try? result?.get()) ?? []
        }

        var error: Error? {
            switch result {
            case let .failure(error):
                return error
            case .success, .none:
                return nil
            }
        }
    }

    @CasePathable
    public enum Action: Equatable {
        case queryChanged(String)
        case searchCompleted(Result)
    }

    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .queryChanged(newQuery):

            state.query = newQuery

            return .run { send in
                await send(.searchCompleted(await searchTracks(newQuery, urlSession, jsonDecoder)))
            }.debounce(
                id: DebounceId.instance,
                for: 0.5,
                scheduler: mainQueue
            )
        case let .searchCompleted(result):
            state.result = result
            return .none
        }
    }

    private enum DebounceId: Hashable {
        case instance
    }

    private let jsonDecoder = JSONDecoder()
}
