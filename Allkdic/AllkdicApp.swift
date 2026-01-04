import SwiftUI

@main
struct AllkdicApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    Settings {
      PreferencesView()
    }

    Window(gettext("about"), id: "about") {
      AboutView()
    }
    .windowStyle(.hiddenTitleBar)
    .windowResizability(.contentSize)
    .defaultPosition(.center)
  }
}
