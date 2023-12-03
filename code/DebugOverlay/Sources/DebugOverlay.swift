import SwiftUI
import ComposableArchitecture
import Core
import UI

@Reducer
public struct DebugOverlay {
    @Dependency(\.suspendingClock) var clock

    public init() {}

    @ObservableState
    public struct State: Equatable {
        public var alignment: Alignment
        public var isRotating: Bool
        public var angle: Angle
        public var rotationDuration: Duration

        public init(
            alignment: Alignment = .bottomTrailing,
            isRotating: Bool = false,
            angle: Angle = .zero,
            rotationDuration: Duration = .seconds(1)
        ) {
            self.alignment = alignment
            self.isRotating = isRotating
            self.angle = angle
            self.rotationDuration = rotationDuration
        }
    }

    @CasePathable
    public enum Action: Equatable {
        case move(Direction2D)
        case toggleRotation
        case rotate(Angle)
    }

    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .move(direction):
            state.alignment.move(to: direction)
            return .none
        case let .rotate(angle):
            state.angle += angle
            return .none
        case .toggleRotation:
            state.isRotating.toggle()

            enum RotationId: Hashable {
                case instance
            }

            if state.isRotating {
                let rotationDuration = state.rotationDuration
                return .run { send in
                    await send(.rotate(Angle(degrees: 360)))
                    for await _ in clock.timer(interval: rotationDuration, tolerance: .zero) {
                        await send(.rotate(Angle(degrees: 360)))
                    }
                }.cancellable(id: RotationId.instance)
            } else {
                return .cancel(id: RotationId.instance)
            }
        }
    }
}
