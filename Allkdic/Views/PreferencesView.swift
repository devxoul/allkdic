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

struct PreferencesView: View {
  @State private var currentKeyBinding: KeyBinding?
  @State private var isRecordingHotKey = false
  @State private var launchAtLogin = LoginItem.enabled

  var body: some View {
    Form {
      Section {
        HStack {
          Text(gettext("shortcut"))
            .frame(width: 110, alignment: .trailing)

          HotKeyRecorderView(
            keyBinding: $currentKeyBinding,
            isRecording: $isRecordingHotKey
          )
          .frame(width: 180)
        }

        HStack {
          Text(gettext("launch_at_login"))
            .frame(width: 110, alignment: .trailing)

          Toggle("", isOn: $launchAtLogin)
            .labelsHidden()
            .onChange(of: launchAtLogin) { _, newValue in
              LoginItem.setEnabled(newValue)
            }

          Spacer()
        }
      }
    }
    .formStyle(.grouped)
    .frame(width: 380, height: 160)
    .onAppear {
      loadCurrentKeyBinding()
      AKHotKeyManager.unregisterHotKey()
    }
    .onDisappear {
      AKHotKeyManager.registerHotKey()
    }
  }

  private func loadCurrentKeyBinding() {
    let keyBindingData = UserDefaults.standard.dictionary(forKey: UserDefaultsKey.hotKey)
    currentKeyBinding = KeyBinding(dictionary: keyBindingData)
  }
}

struct HotKeyRecorderView: View {
  @Binding var keyBinding: KeyBinding?
  @Binding var isRecording: Bool

  var body: some View {
    HStack(spacing: 4) {
      if let kb = keyBinding {
        ModifierKeyView(symbol: "⇧", isActive: kb.shift)
        ModifierKeyView(symbol: "⌃", isActive: kb.control)
        ModifierKeyView(symbol: "⌥", isActive: kb.option)
        ModifierKeyView(symbol: "⌘", isActive: kb.command)

        if let keyString = KeyBinding.keyStringFormKeyCode(kb.keyCode) {
          Text(keyString.capitalized)
            .font(.system(size: 13, weight: .medium))
        }
      }
    }
    .padding(.horizontal, 10)
    .frame(height: 28)
    .background(Color(nsColor: .controlBackgroundColor))
    .cornerRadius(6)
    .overlay(
      RoundedRectangle(cornerRadius: 6)
        .stroke(Color(nsColor: .separatorColor), lineWidth: 1)
    )
    .focusable()
    .onKeyPress { keyPress in
      handleKeyPress(keyPress)
      return .handled
    }
  }

  private func handleKeyPress(_ keyPress: KeyPress) {
    let modifiers = keyPress.modifiers
    let hasModifier = modifiers.contains(.shift) ||
                      modifiers.contains(.control) ||
                      modifiers.contains(.option) ||
                      modifiers.contains(.command)

    guard hasModifier else { return }

    let newKeyBinding = KeyBinding()
    newKeyBinding.shift = modifiers.contains(.shift)
    newKeyBinding.control = modifiers.contains(.control)
    newKeyBinding.option = modifiers.contains(.option)
    newKeyBinding.command = modifiers.contains(.command)

    if let keyCode = keyCodeFromCharacter(keyPress.characters) {
      newKeyBinding.keyCode = keyCode
    }

    keyBinding = newKeyBinding
    UserDefaults.standard.set(newKeyBinding.toDictionary(), forKey: UserDefaultsKey.hotKey)
    UserDefaults.standard.synchronize()
  }

  private func keyCodeFromCharacter(_ character: String) -> Int? {
    for (code, str) in keyMap where str.lowercased() == character.lowercased() {
      return code
    }
    return nil
  }
}

struct ModifierKeyView: View {
  let symbol: String
  let isActive: Bool

  var body: some View {
    Text(symbol)
      .font(.system(size: 14, weight: .medium))
      .foregroundStyle(isActive ? .primary : .tertiary)
  }
}

#Preview {
  PreferencesView()
}
