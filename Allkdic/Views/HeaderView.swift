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

        Text(hotKeyDescription)
          .font(.system(size: 12))
          .foregroundStyle(.secondary)
      }

      HStack {
        Spacer()
        Menu {
          Menu(gettext("change_dictionary")) {
            ForEach(Array(DictionaryType.allTypes.enumerated()), id: \.element) { index, dictionary in
              Button {
                let previous = selectedDictionary
                selectedDictionary = dictionary
                DictionaryType.selectedDictionary = dictionary
                if previous != dictionary {
                  AnalyticsHelper.shared.trackDictionarySwitched(from: previous, to: dictionary)
                }
              } label: {
                HStack {
                  Text(dictionary.title)
                  if dictionary == selectedDictionary {
                    Image(systemName: "checkmark")
                  }
                }
              }
              .keyboardShortcut(KeyEquivalent(Character("\(index + 1)")), modifiers: .command)
            }
          }

          Divider()

          Button(gettext("about")) {
            openAboutWindow()
          }

          Button(gettext("preferences") + "...") {
            openPreferences()
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
      updateHotKeyDescription()
    }
    .onReceive(NotificationCenter.default.publisher(for: .hotKeyDidChange)) { _ in
      updateHotKeyDescription()
    }
  }

  private func updateHotKeyDescription() {
    let keyBindingData = UserDefaults.standard.dictionary(forKey: UserDefaultsKey.hotKey)
    if let keyBinding = KeyBinding(dictionary: keyBindingData) {
      hotKeyDescription = keyBinding.description
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

  func makeNSView(context: Context) -> NSVisualEffectView {
    let view = NSVisualEffectView()
    view.material = material
    view.blendingMode = blendingMode
    view.state = .active
    return view
  }

  func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
    nsView.material = material
    nsView.blendingMode = blendingMode
  }
}

#Preview {
  HeaderView(selectedDictionary: .constant(.Naver))
    .frame(width: 420)
}
