// Copyright 2022 Yandex LLC. All rights reserved.

import SwiftUI

@main
struct MusicPlayerApp: App {
  var body: some Scene {
    WindowGroup {
      ZStack {
        SearchList(search: Searcher().search) { song in
          TrackView(song, formatter: formatter, visibility: visibility)
        }
        DebugView(visibility: $visibility).background(.clear)
      }
    }
  }

  private let formatter = DateComponentsFormatter()

  @State
  private var visibility = false
}

struct DebugView: View {
  @Binding
  var visibility: Bool

  var body: some View {
    Group {
      VStack {
        HStack {
          Button {
            if alignment.horizontal == .leading {
              alignment = .topLeading
            } else {
              alignment = .topTrailing
            }
          } label: {
            Image(systemName: "arrow.up")
          }
        }
        HStack {
          Button {
            if alignment.vertical == .top {
              alignment = .topLeading
            } else {
              alignment = .bottomLeading
            }
          } label: {
            Image(systemName: "arrow.left")
          }
          Menu {
            Button {
              visibility.toggle()
            } label: {
              HStack {
                Text("Visibility")
                Spacer()
                if visibility {
                  Image(systemName: "checkmark")
                }
              }
            }
          } label: {
            Image(systemName: "ladybug")
          }

          Button {
            if alignment.vertical == .top {
              alignment = .topTrailing
            } else {
              alignment = .bottomTrailing
            }
          } label: {
            Image(systemName: "arrow.right")
          }
        }
        HStack {
          Button {
            if alignment.horizontal == .leading {
              alignment = .bottomLeading
            } else {
              alignment = .bottomTrailing
            }
          } label: {
            Image(systemName: "arrow.down")
          }
        }
      }
    }
    .padding()
    .background(Color.black.opacity(0.1))
    .cornerRadius(8)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    .padding()
    .tint(.primary)
    .animation(.default, value: alignment)
  }

  @State
  private var alignment = Alignment.bottomTrailing
}

struct DebugView_Previews: PreviewProvider {
  static var previews: some View {
    DebugView(visibility: $visibility)
  }

  @State
  private static var visibility: Bool = false
}
