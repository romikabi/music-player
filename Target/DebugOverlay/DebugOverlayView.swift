import SwiftUI
import ComposableArchitecture
import Core

public struct DebugOverlayView: View {
  public let store: StoreOf<DebugOverlay>

  public init(store: StoreOf<DebugOverlay>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store) { viewStore in
      Grid {
        GridRow {
          Button.arrow(.upLeft, send: { viewStore.send(.move($0)) })
          Button.arrow(.up, send: { viewStore.send(.move($0)) })
          Button.arrow(.upRight, send: { viewStore.send(.move($0)) })
        }
        GridRow {
          Button.arrow(.left, send: { viewStore.send(.move($0)) })
          Menu {
            Button {
              viewStore.send(.toggleRotation)
            } label: {
              HStack {
                Text("Rotate")
                Spacer()
                if viewStore.isRotating {
                  Image(systemName: "checkmark")
                }
              }
            }
          } label: {
            Image(systemName: "ladybug")
              .rotationEffect(viewStore.angle)
              .animation(
                .linear(duration: viewStore.rotationDuration.timeInterval),
                value: viewStore.angle
              )
          }
          Button.arrow(.right, send: { viewStore.send(.move($0)) })
        }
        GridRow {
          Button.arrow(.downLeft, send: { viewStore.send(.move($0)) })
          Button.arrow(.down, send: { viewStore.send(.move($0)) })
          Button.arrow(.downRight, send: { viewStore.send(.move($0)) })
        }
      }
      .padding()
      .background(Color.black.opacity(0.1))
      .cornerRadius(8)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: viewStore.alignment)
      .padding()
      .tint(.primary)
      .animation(.default, value: viewStore.alignment)
    }
  }
}

struct DebugView_Previews: PreviewProvider {
  static var previews: some View {
    DebugOverlayView(store: .init(initialState: .init(), reducer: DebugOverlay()))
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
