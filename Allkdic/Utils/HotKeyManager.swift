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

import Carbon
import Cocoa

enum HotKeyManager {
  nonisolated(unsafe) private static var hotKeyRef: EventHotKeyRef?

  static func registerHotKey() {
    var eventType = EventTypeSpec(
      eventClass: OSType(kEventClassKeyboard),
      eventKind: UInt32(kEventHotKeyPressed)
    )

    let handler: EventHandlerUPP = { (
      _: EventHandlerCallRef?,
      _: EventRef?,
      _: UnsafeMutableRawPointer?
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
      &handlerRef
    )

    let hotKeyID = EventHotKeyID(
      signature: fourCharCode("allk"),
      id: 0
    )

    let keyBinding = loadKeyBinding()
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
      &hotKeyRef
    )
  }

  static func unregisterHotKey() {
    print("Unbind HotKey")
    if let ref = hotKeyRef {
      UnregisterEventHotKey(ref)
      hotKeyRef = nil
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
