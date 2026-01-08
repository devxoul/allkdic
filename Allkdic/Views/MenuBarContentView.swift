import SwiftUI

struct MenuBarContentView: View {
  @State private var selectedDictionary = DictionaryType.selectedDictionary
  @State private var keyMonitor: Any?

  var body: some View {
    VStack(spacing: 0) {
      HeaderView(selectedDictionary: self.$selectedDictionary)
      Divider()
      DictionaryWebView(dictionary: self.selectedDictionary)
    }
    .onAppear { self.setupKeyMonitor() }
    .onDisappear { self.removeKeyMonitor() }
  }

  private func setupKeyMonitor() {
    self.keyMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
      guard event.modifierFlags.contains(.command) else { return event }

      let allTypes = DictionaryType.allTypes
      for (index, dictionary) in allTypes.enumerated() {
        if event.charactersIgnoringModifiers == "\(index + 1)" {
          let previous = self.selectedDictionary
          self.selectedDictionary = dictionary
          DictionaryType.selectedDictionary = dictionary
          if previous != dictionary {
            AnalyticsHelper.shared.trackDictionarySwitched(from: previous, to: dictionary)
          }
          return nil
        }
      }
      return event
    }
  }

  private func removeKeyMonitor() {
    if let monitor = keyMonitor {
      NSEvent.removeMonitor(monitor)
      self.keyMonitor = nil
    }
  }
}

#Preview {
  MenuBarContentView()
    .frame(width: 420, height: 580)
}
