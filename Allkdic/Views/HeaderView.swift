// The MIT License (MIT)
//
// Copyright (c) 2013 Suyeol Jeon (http://xoul.kr)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import SwiftUI

struct HeaderView: View {
  @Binding var selectedDictionary: DictionaryType
  @State private var hotKeyDescription: String = ""
  @Environment(\.openSettings) private var openSettings

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
                selectedDictionary = dictionary
                DictionaryType.selectedDictionary = dictionary
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
            openSettings()
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
  }

  private func updateHotKeyDescription() {
    let keyBindingData = UserDefaults.standard.dictionary(forKey: UserDefaultsKey.hotKey)
    let keyBinding = KeyBinding(dictionary: keyBindingData)
    hotKeyDescription = keyBinding.description
  }

  private func openAboutWindow() {
    NSApp.sendAction(#selector(AppDelegate.openAboutWindow), to: nil, from: nil)
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
