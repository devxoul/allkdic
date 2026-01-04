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
    HotKeyRecorderRepresentable(keyBinding: $keyBinding, isRecording: $isRecording)
      .frame(height: 28)
  }
}

struct HotKeyRecorderRepresentable: NSViewRepresentable {
  @Binding var keyBinding: KeyBinding?
  @Binding var isRecording: Bool

  func makeNSView(context: Context) -> HotKeyRecorderField {
    let field = HotKeyRecorderField()
    field.delegate = context.coordinator
    field.keyBinding = keyBinding
    return field
  }

  func updateNSView(_ nsView: HotKeyRecorderField, context: Context) {
    nsView.keyBinding = keyBinding
    nsView.isRecording = isRecording
    nsView.needsDisplay = true
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  @MainActor
  class Coordinator: NSObject, HotKeyRecorderFieldDelegate {
    let parent: HotKeyRecorderRepresentable

    init(_ parent: HotKeyRecorderRepresentable) {
      self.parent = parent
    }

    nonisolated func hotKeyRecorderFieldDidStartRecording(_ field: HotKeyRecorderField) {
      Task { @MainActor in
        parent.isRecording = true
      }
    }

    nonisolated func hotKeyRecorderFieldDidEndRecording(_ field: HotKeyRecorderField, keyBinding: KeyBinding?) {
      let dict = keyBinding?.toDictionary()
      Task { @MainActor in
        parent.isRecording = false
        if let dict = dict {
          let kb = KeyBinding(dictionary: dict)
          parent.keyBinding = kb
          UserDefaults.standard.set(dict, forKey: UserDefaultsKey.hotKey)
          NotificationCenter.default.post(name: .hotKeyDidChange, object: nil)
        }
        HotKeyManager.registerHotKey()
      }
    }
  }
}

protocol HotKeyRecorderFieldDelegate: AnyObject {
  func hotKeyRecorderFieldDidStartRecording(_ field: HotKeyRecorderField)
  func hotKeyRecorderFieldDidEndRecording(_ field: HotKeyRecorderField, keyBinding: KeyBinding?)
}

class HotKeyRecorderField: NSView {
  weak var delegate: HotKeyRecorderFieldDelegate?
  var keyBinding: KeyBinding?
  var isRecording = false {
    didSet { needsDisplay = true }
  }

  private var currentModifiers: NSEvent.ModifierFlags = []

  override var acceptsFirstResponder: Bool { true }

  override func draw(_ dirtyRect: NSRect) {
    let bgColor: NSColor = isRecording ? NSColor.controlAccentColor.withAlphaComponent(0.15) : .controlBackgroundColor
    bgColor.setFill()
    let path = NSBezierPath(roundedRect: bounds, xRadius: 6, yRadius: 6)
    path.fill()

    let borderColor: NSColor = isRecording ? .controlAccentColor : .separatorColor
    borderColor.setStroke()
    path.lineWidth = 1
    path.stroke()

    let displayBinding: KeyBinding?
    if isRecording && !currentModifiers.isEmpty {
      var kb = KeyBinding()
      kb.shift = currentModifiers.contains(.shift)
      kb.control = currentModifiers.contains(.control)
      kb.option = currentModifiers.contains(.option)
      kb.command = currentModifiers.contains(.command)
      kb.keyCode = keyBinding?.keyCode ?? 0
      displayBinding = kb
    } else {
      displayBinding = keyBinding
    }
    
    let symbols: [(String, Bool)] = [
      ("⇧", displayBinding?.shift ?? false),
      ("⌃", displayBinding?.control ?? false),
      ("⌥", displayBinding?.option ?? false),
      ("⌘", displayBinding?.command ?? false)
    ]
    
    let attributedString = NSMutableAttributedString()
    
    for (symbol, isActive) in symbols {
      let color: NSColor = isActive ? .labelColor : .tertiaryLabelColor
      attributedString.append(NSAttributedString(string: symbol + " ", attributes: [
        .font: NSFont.systemFont(ofSize: 14, weight: .medium),
        .foregroundColor: color
      ]))
    }
    
    if let keyCode = displayBinding?.keyCode,
       let keyString = KeyBinding.keyStringFormKeyCode(keyCode) {
      attributedString.append(NSAttributedString(string: keyString.capitalized, attributes: [
        .font: NSFont.systemFont(ofSize: 13, weight: .medium),
        .foregroundColor: NSColor.labelColor
      ]))
    }
    
    let rect = attributedString.boundingRect(with: bounds.size, options: [])
    let origin = NSPoint(
      x: 10,
      y: (bounds.height - rect.height) / 2
    )
    attributedString.draw(at: origin)
  }

  override func mouseDown(with event: NSEvent) {
    if isRecording {
      stopRecording(with: nil)
    } else {
      startRecording()
    }
  }

  override func keyDown(with event: NSEvent) {
    guard isRecording else { return }

    let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
    let hasModifier = flags.contains(.shift) || flags.contains(.control) ||
                      flags.contains(.option) || flags.contains(.command)

    guard hasModifier else { return }

    var kb = KeyBinding()
    kb.shift = flags.contains(.shift)
    kb.control = flags.contains(.control)
    kb.option = flags.contains(.option)
    kb.command = flags.contains(.command)
    kb.keyCode = Int(event.keyCode)

    stopRecording(with: kb)
  }

  override func flagsChanged(with event: NSEvent) {
    guard isRecording else { return }
    currentModifiers = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
    needsDisplay = true
  }

  private func startRecording() {
    HotKeyManager.unregisterHotKey()
    isRecording = true
    currentModifiers = []
    window?.makeFirstResponder(self)
    delegate?.hotKeyRecorderFieldDidStartRecording(self)
  }

  private func stopRecording(with keyBinding: KeyBinding?) {
    isRecording = false
    currentModifiers = []
    delegate?.hotKeyRecorderFieldDidEndRecording(self, keyBinding: keyBinding)
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
