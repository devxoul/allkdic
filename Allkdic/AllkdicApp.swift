import SwiftUI

@main
struct AllkdicApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    Window("", id: "dummy") {
      Color.clear
        .frame(width: 0, height: 0)
    }
    .windowStyle(.hiddenTitleBar)
    .windowResizability(.contentSize)
  }
}
