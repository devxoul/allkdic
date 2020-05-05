//
//  HotKeyService.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 2020/05/04.
//

import Carbon

protocol HotKeyServiceProtocol {
  func register(keyBinding: KeyBinding)
  func unregister()
}

final class HotKeyService: HotKeyServiceProtocol {
  typealias InstallEventHandler = (
    _ inTarget: EventTargetRef?,
    _ inHandler: EventHandlerUPP?,
    _ inNumTypes: Int,
    _ inList: UnsafePointer<EventTypeSpec>?,
    _ inUserData: UnsafeMutableRawPointer?,
    _ outRef: UnsafeMutablePointer<EventHandlerRef?>?
  ) -> OSStatus
  typealias RegisterEventHotKey = (
    _ inHotKeyCode: UInt32,
    _ inHotKeyModifiers: UInt32,
    _ inHotKeyID: EventHotKeyID,
    _ inTarget: EventTargetRef?,
    _ inOptions: OptionBits,
    _ outRef: UnsafeMutablePointer<EventHotKeyRef?>?
  ) -> OSStatus
  typealias UnregisterEventHotKey = (_ inHotKey: EventHotKeyRef?) -> OSStatus

  private struct EventHandlerUserData {
    let notificationCenter: NotificationCenter
  }

  private let installEventHandler: InstallEventHandler
  private let registerEventHotKey: RegisterEventHotKey
  private let unregisterEventHotKey: UnregisterEventHotKey

  private var eventHandlerUserData: EventHandlerUserData
  private var eventHandler: EventHandlerRef?
  private var eventHotKey: EventHotKeyRef?


  // MARK: Initializing

  init(
    installEventHandler: @escaping InstallEventHandler,
    registerEventHotKey: @escaping RegisterEventHotKey,
    unregisterEventHotKey: @escaping UnregisterEventHotKey,
    notificationCenter: NotificationCenter
  ) {
    self.installEventHandler = installEventHandler
    self.registerEventHotKey = registerEventHotKey
    self.unregisterEventHotKey = unregisterEventHotKey
    self.eventHandlerUserData = EventHandlerUserData(
      notificationCenter: notificationCenter
    )
  }


  // MARK: Registering Hot Key

  func register(keyBinding: KeyBinding) {
    self.installHander()
    self.registerHotKey(keyBinding: keyBinding)
  }

  private func installHander() {
    guard self.eventHandler == nil else { return }
    let eventTarget = GetApplicationEventTarget()
    var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
    _ = self.installEventHandler(eventTarget, Self.hotKeyHandler, 1, &eventType, &self.eventHandlerUserData, &self.eventHandler)
  }

  private func registerHotKey(keyBinding: KeyBinding) {
    guard self.eventHotKey == nil else { return }
    let hotKeyModifiers = self.keyModifiers(from: keyBinding)
    let hotKeyID = EventHotKeyID(signature: FourCharCode("a", "l", "l", "k").rawValue, id: 0)
    let eventTarget = GetApplicationEventTarget()
    _ = self.registerEventHotKey(UInt32(keyBinding.keyCode), hotKeyModifiers, hotKeyID, eventTarget, 0, &self.eventHotKey)
  }

  private func keyModifiers(from keyBinding: KeyBinding) -> UInt32 {
    var hotKeyModifiers = 0
    if keyBinding.shift {
      hotKeyModifiers += Carbon.shiftKey
    }
    if keyBinding.option {
      hotKeyModifiers += Carbon.optionKey
    }
    if keyBinding.control {
      hotKeyModifiers += Carbon.controlKey
    }
    if keyBinding.command {
      hotKeyModifiers += Carbon.cmdKey
    }
    return UInt32(hotKeyModifiers)
  }


  // MARK: Unregistering Hot Key

  func unregister() {
    _ = self.unregisterEventHotKey(self.eventHotKey)
  }


  // MARK: Handler

  fileprivate static let hotKeyHandler: EventHandlerUPP = { eventHandlerCall, event, userData in
    let notificationCenter = userData?.assumingMemoryBound(to: EventHandlerUserData.self).pointee.notificationCenter
    notificationCenter?.post(name: .globalHotKeyPressed, object: nil)
    return noErr
  }
}

extension Notification.Name {
  static let globalHotKeyPressed = Notification.Name(rawValue: "globalHotKeyPressed")
}

#if DEBUG
import Testables

extension HotKeyService: Testable {
  final class TestableKeys: TestableKey<Self> {
  }
}

extension TestableProtocol where Base: HotKeyService {
  var hotKeyHandler: EventHandlerUPP {
    return Base.hotKeyHandler
  }
}
#endif
