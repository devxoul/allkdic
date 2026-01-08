import Carbon
import Cocoa

enum HotKeyManager {
  private nonisolated(unsafe) static var hotKeyRef: EventHotKeyRef?

  static func registerHotKey() {
    var eventType = EventTypeSpec(
      eventClass: OSType(kEventClassKeyboard),
      eventKind: UInt32(kEventHotKeyPressed),
    )

    let handler: EventHandlerUPP = { (
      _: EventHandlerCallRef?,
      _: EventRef?,
      _: UnsafeMutableRawPointer?,
    ) -> OSStatus in
      Task { @MainActor in
        AppDelegate.shared.openPopover()
      }
      return noErr
    }

    var handlerRef: EventHandlerRef?
    InstallEventHandler(
      GetApplicationEventTarget(),
      handler,
      1,
      &eventType,
      nil,
      &handlerRef,
    )

    let hotKeyID = EventHotKeyID(
      signature: fourCharCode("allk"),
      id: 0,
    )

    let keyBinding = self.loadKeyBinding()
    print("Bind HotKey: \(keyBinding)")

    var hotKeyModifiers: UInt32 = 0
    if keyBinding.shift { hotKeyModifiers += UInt32(shiftKey) }
    if keyBinding.option { hotKeyModifiers += UInt32(optionKey) }
    if keyBinding.control { hotKeyModifiers += UInt32(controlKey) }
    if keyBinding.command { hotKeyModifiers += UInt32(cmdKey) }

    RegisterEventHotKey(
      UInt32(keyBinding.keyCode),
      hotKeyModifiers,
      hotKeyID,
      GetApplicationEventTarget(),
      0,
      &self.hotKeyRef,
    )
  }

  static func unregisterHotKey() {
    print("Unbind HotKey")
    if let ref = hotKeyRef {
      UnregisterEventHotKey(ref)
      self.hotKeyRef = nil
    }
  }

  private static func loadKeyBinding() -> KeyBinding {
    if let data = UserDefaults.standard.dictionary(forKey: UserDefaultsKey.hotKey),
       let keyBinding = KeyBinding(dictionary: data) {
      return keyBinding
    } else {
      print("No existing key setting.")
      var keyBinding = KeyBinding()
      keyBinding.option = true
      keyBinding.command = true
      keyBinding.keyCode = 49
      UserDefaults.standard.set(keyBinding.toDictionary(), forKey: UserDefaultsKey.hotKey)
      return keyBinding
    }
  }

  private static func fourCharCode(_ string: String) -> FourCharCode {
    var result: FourCharCode = 0
    for char in string.utf8.prefix(4) {
      result = (result << 8) + FourCharCode(char)
    }
    return result
  }
}
