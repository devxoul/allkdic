import SwiftUI

struct HeaderView: View {
  @Binding var selectedDictionary: DictionaryType
  @State private var hotKeyDescription: String = ""

  var body: some View {
    ZStack {
      VisualEffectView(material: .headerView, blendingMode: .withinWindow)

      VStack(spacing: 4) {
        Text(BundleInfo.bundleName)
          .font(.system(size: 17, weight: .semibold))
          .foregroundStyle(.primary)

        Text(self.hotKeyDescription)
          .font(.system(size: 12))
          .foregroundStyle(.secondary)
      }

      HStack {
        Spacer()
        Menu {
          Menu(gettext("change_dictionary")) {
            ForEach(Array(DictionaryType.allTypes.enumerated()), id: \.element) { index, dictionary in
              Button {
                let previous = self.selectedDictionary
                self.selectedDictionary = dictionary
                DictionaryType.selectedDictionary = dictionary
                if previous != dictionary {
                  AnalyticsHelper.shared.trackDictionarySwitched(from: previous, to: dictionary)
                }
              } label: {
                HStack {
                  Text(dictionary.title)
                  if dictionary == self.selectedDictionary {
                    Image(systemName: "checkmark")
                  }
                }
              }
              .keyboardShortcut(KeyEquivalent(Character("\(index + 1)")), modifiers: .command)
            }
          }

          Divider()

          Button(gettext("about")) {
            self.openAboutWindow()
          }

          Button(gettext("preferences") + "...") {
            self.openPreferences()
          }
          .keyboardShortcut(",", modifiers: .command)

          Divider()

          Button(gettext("quit")) {
            NSApplication.shared.terminate(nil)
          }
        } label: {
          Image(systemName: "gearshape")
            .foregroundStyle(.secondary)
        }
        .menuStyle(.borderlessButton)
        .menuIndicator(.hidden)
        .frame(width: 24, height: 24)
      }
      .padding(.horizontal, 14)
    }
    .frame(height: 64)
    .onAppear {
      self.updateHotKeyDescription()
    }
    .onReceive(NotificationCenter.default.publisher(for: .hotKeyDidChange)) { _ in
      self.updateHotKeyDescription()
    }
  }

  private func updateHotKeyDescription() {
    let keyBindingData = UserDefaults.standard.dictionary(forKey: UserDefaultsKey.hotKey)
    if let keyBinding = KeyBinding(dictionary: keyBindingData) {
      self.hotKeyDescription = keyBinding.description
    }
  }

  private func openAboutWindow() {
    AppDelegate.shared.closePopover()
    AppDelegate.shared.openAboutWindow()
  }

  private func openPreferences() {
    AppDelegate.shared.closePopover()
    AppDelegate.shared.openPreferencesWindow()
  }
}

struct VisualEffectView: NSViewRepresentable {
  let material: NSVisualEffectView.Material
  let blendingMode: NSVisualEffectView.BlendingMode

  func makeNSView(context _: Context) -> NSVisualEffectView {
    let view = NSVisualEffectView()
    view.material = self.material
    view.blendingMode = self.blendingMode
    view.state = .active
    return view
  }

  func updateNSView(_ nsView: NSVisualEffectView, context _: Context) {
    nsView.material = self.material
    nsView.blendingMode = self.blendingMode
  }
}

#Preview {
  HeaderView(selectedDictionary: .constant(.Naver))
    .frame(width: 420)
}
