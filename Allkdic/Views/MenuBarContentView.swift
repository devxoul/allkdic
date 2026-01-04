import SwiftUI

struct MenuBarContentView: View {
  @State private var selectedDictionary = DictionaryType.selectedDictionary
  @State private var keyMonitor: Any?

  var body: some View {
    VStack(spacing: 0) {
      HeaderView(selectedDictionary: $selectedDictionary)
      Divider()
      DictionaryWebView(dictionary: selectedDictionary)
    }
    .onAppear { setupKeyMonitor() }
    .onDisappear { removeKeyMonitor() }
  }

  private func setupKeyMonitor() {
    keyMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
      guard event.modifierFlags.contains(.command) else { return event }

      let allTypes = DictionaryType.allTypes
      for (index, dictionary) in allTypes.enumerated() {
        if event.charactersIgnoringModifiers == "\(index + 1)" {
          selectedDictionary = dictionary
          DictionaryType.selectedDictionary = dictionary
          return nil
        }
      }
      return event
    }
  }

  private func removeKeyMonitor() {
    if let monitor = keyMonitor {
      NSEvent.removeMonitor(monitor)
      keyMonitor = nil
    }
  }
}

#Preview {
  MenuBarContentView()
    .frame(width: 420, height: 580)
}
