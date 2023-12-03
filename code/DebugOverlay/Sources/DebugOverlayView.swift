import SwiftUI
import ComposableArchitecture
import Core

public struct DebugOverlayView: View {
    @State private var store: StoreOf<DebugOverlay>

    public init(store: StoreOf<DebugOverlay>) {
        self.store = store
    }

    public var body: some View {
        Grid {
            GridRow {
                Button.arrow(.upLeft, send: { store.send(.move($0)) })
                Button.arrow(.up, send: { store.send(.move($0)) })
                Button.arrow(.upRight, send: { store.send(.move($0)) })
            }
            GridRow {
                Button.arrow(.left, send: { store.send(.move($0)) })
                Menu {
                    Button {
                        store.send(.toggleRotation)
                    } label: {
                        HStack {
                            Text("Rotate")
                            Spacer()
                            if store.isRotating {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                } label: {
                    Image(systemName: "ladybug")
                        .rotationEffect(store.angle)
                        .animation(
                            .linear(duration: store.rotationDuration.timeInterval),
                            value: store.angle
                        )
                }
                Button.arrow(.right, send: { store.send(.move($0)) })
            }
            GridRow {
                Button.arrow(.downLeft, send: { store.send(.move($0)) })
                Button.arrow(.down, send: { store.send(.move($0)) })
                Button.arrow(.downRight, send: { store.send(.move($0)) })
            }
        }
        .padding()
        .background(Color.black.opacity(0.1))
        .cornerRadius(8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: store.alignment)
        .padding()
        .tint(.primary)
        .animation(.default, value: store.alignment)
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugOverlayView(store: .init(initialState: .init(), reducer: {
            DebugOverlay()
        }))
    }
}

extension Button where Label == Image {
    fileprivate static func arrow(_ direction: Direction2D, send: @escaping (Direction2D) -> Void) -> Self {
        Self {
            send(direction)
        } label: {
            direction.arrow
        }
    }
}

extension Direction2D {
    fileprivate var arrow: Image {
        Image(systemName: "arrow.\(systemNameSuffix)")
    }

    private var systemNameSuffix: String {
        switch self {
        case .left:
            return "left"
        case .upLeft:
            return "up.left"
        case .up:
            return "up"
        case .upRight:
            return "up.right"
        case .right:
            return "right"
        case .downRight:
            return "down.right"
        case .down:
            return "down"
        case .downLeft:
            return "down.left"
        }
    }
}
