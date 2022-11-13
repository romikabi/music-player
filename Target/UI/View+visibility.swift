import SwiftUI

extension View {
  @ViewBuilder func visibility(_ enabled: Bool) -> some View {
    if enabled {
      border(Color.random)
    } else {
      self
    }
  }
}
