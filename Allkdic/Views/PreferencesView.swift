import ServiceManagement
import SwiftUI

struct PreferencesView: View {
  @State private var currentKeyBinding: KeyBinding?
  @State private var isRecordingHotKey = false
  @State private var launchAtLogin = LoginItem.enabled
  @State private var showLoginItemError = false
  @State private var loginItemErrorMessage = ""

  var body: some View {
    Form {
      Section {
        HStack(spacing: 16) {
          Text(gettext("shortcut"))
            .frame(width: 140, alignment: .trailing)

          HotKeyRecorderView(
            keyBinding: self.$currentKeyBinding,
            isRecording: self.$isRecordingHotKey,
          )
          .frame(width: 180)
        }
        .frame(height: 28)

        HStack(spacing: 16) {
          Text(gettext("launch_at_login"))
            .frame(width: 140, alignment: .trailing)

          Toggle("", isOn: self.$launchAtLogin)
            .labelsHidden()
            .onChange(of: self.launchAtLogin) { _, newValue in
              do {
                try LoginItem.setEnabled(newValue)
              } catch {
                self.loginItemErrorMessage = error.localizedDescription
                self.showLoginItemError = true
                self.launchAtLogin = LoginItem.enabled
              }
            }

          if LoginItem.requiresApproval {
            Button {
              SMAppService.openSystemSettingsLoginItems()
            } label: {
              Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.yellow)
            }
            .buttonStyle(.plain)
            .help(gettext("login_item_requires_approval"))
          }

          Spacer()
        }
        .frame(height: 28)
      }
    }
    .formStyle(.grouped)
    .padding(.vertical, 8)
    .frame(width: 400, height: 160)
    .onAppear {
      self.loadCurrentKeyBinding()
      self.launchAtLogin = LoginItem.enabled
    }
    .alert(gettext("error"), isPresented: self.$showLoginItemError) {
      Button(gettext("ok")) {}
    } message: {
      Text(self.loginItemErrorMessage)
    }
  }

  private func loadCurrentKeyBinding() {
    let keyBindingData = UserDefaults.standard.dictionary(forKey: UserDefaultsKey.hotKey)
    self.currentKeyBinding = KeyBinding(dictionary: keyBindingData)
  }
}

struct HotKeyRecorderView: View {
  @Binding var keyBinding: KeyBinding?
  @Binding var isRecording: Bool

  var body: some View {
    HotKeyRecorderRepresentable(keyBinding: self.$keyBinding, isRecording: self.$isRecording)
      .frame(height: 28)
  }
}

struct HotKeyRecorderRepresentable: NSViewRepresentable {
  @Binding var keyBinding: KeyBinding?
  @Binding var isRecording: Bool

  func makeNSView(context: Context) -> HotKeyRecorderField {
    let field = HotKeyRecorderField()
    field.delegate = context.coordinator
    field.keyBinding = self.keyBinding
    return field
  }

  func updateNSView(_ nsView: HotKeyRecorderField, context _: Context) {
    nsView.keyBinding = self.keyBinding
    nsView.isRecording = self.isRecording
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

    nonisolated func hotKeyRecorderFieldDidStartRecording(_: HotKeyRecorderField) {
      Task { @MainActor in
        self.parent.isRecording = true
      }
    }

    nonisolated func hotKeyRecorderFieldDidEndRecording(_: HotKeyRecorderField, keyBinding: KeyBinding?) {
      let dict = keyBinding?.toDictionary()
      Task { @MainActor in
        self.parent.isRecording = false
        if let dict {
          let kb = KeyBinding(dictionary: dict)
          self.parent.keyBinding = kb
          UserDefaults.standard.set(dict, forKey: UserDefaultsKey.hotKey)
          NotificationCenter.default.post(name: .hotKeyDidChange, object: nil)
          AnalyticsHelper.shared.trackHotkeyUpdated()
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

  override func draw(_: NSRect) {
    let bgColor: NSColor = self.isRecording ? NSColor.controlAccentColor.withAlphaComponent(0.15) : .controlBackgroundColor
    bgColor.setFill()
    let path = NSBezierPath(roundedRect: bounds, xRadius: 6, yRadius: 6)
    path.fill()

    let borderColor: NSColor = self.isRecording ? .controlAccentColor : .separatorColor
    borderColor.setStroke()
    path.lineWidth = 1
    path.stroke()

    let displayBinding: KeyBinding?
    if self.isRecording, !self.currentModifiers.isEmpty {
      var kb = KeyBinding()
      kb.shift = self.currentModifiers.contains(.shift)
      kb.control = self.currentModifiers.contains(.control)
      kb.option = self.currentModifiers.contains(.option)
      kb.command = self.currentModifiers.contains(.command)
      kb.keyCode = self.keyBinding?.keyCode ?? 0
      displayBinding = kb
    } else {
      displayBinding = self.keyBinding
    }

    let symbols: [(String, Bool)] = [
      ("⇧", displayBinding?.shift ?? false),
      ("⌃", displayBinding?.control ?? false),
      ("⌥", displayBinding?.option ?? false),
      ("⌘", displayBinding?.command ?? false),
    ]

    let attributedString = NSMutableAttributedString()

    for (symbol, isActive) in symbols {
      let color: NSColor = isActive ? .labelColor : .tertiaryLabelColor
      attributedString.append(NSAttributedString(string: symbol + " ", attributes: [
        .font: NSFont.systemFont(ofSize: 14, weight: .medium),
        .foregroundColor: color,
      ]))
    }

    if let keyCode = displayBinding?.keyCode,
       let keyString = KeyBinding.keyStringFormKeyCode(keyCode) {
      attributedString.append(NSAttributedString(string: keyString.capitalized, attributes: [
        .font: NSFont.systemFont(ofSize: 13, weight: .medium),
        .foregroundColor: NSColor.labelColor,
      ]))
    }

    let rect = attributedString.boundingRect(with: bounds.size, options: [])
    let origin = NSPoint(
      x: 10,
      y: (bounds.height - rect.height) / 2,
    )
    attributedString.draw(at: origin)
  }

  override func mouseDown(with _: NSEvent) {
    if self.isRecording {
      self.stopRecording(with: nil)
    } else {
      self.startRecording()
    }
  }

  override func keyDown(with event: NSEvent) {
    guard self.isRecording else { return }

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

    self.stopRecording(with: kb)
  }

  override func flagsChanged(with event: NSEvent) {
    guard self.isRecording else { return }
    self.currentModifiers = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
    needsDisplay = true
  }

  private func startRecording() {
    HotKeyManager.unregisterHotKey()
    self.isRecording = true
    self.currentModifiers = []
    window?.makeFirstResponder(self)
    self.delegate?.hotKeyRecorderFieldDidStartRecording(self)
  }

  private func stopRecording(with keyBinding: KeyBinding?) {
    self.isRecording = false
    self.currentModifiers = []
    self.delegate?.hotKeyRecorderFieldDidEndRecording(self, keyBinding: keyBinding)
  }
}

struct ModifierKeyView: View {
  let symbol: String
  let isActive: Bool

  var body: some View {
    Text(self.symbol)
      .font(.system(size: 14, weight: .medium))
      .foregroundStyle(self.isActive ? .primary : .tertiary)
  }
}

#Preview {
  PreferencesView()
}
