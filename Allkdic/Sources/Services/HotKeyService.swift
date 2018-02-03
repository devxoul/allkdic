//
//  HotKeyService.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 04/02/2018.
//  Copyright © 2018 Allkdic. All rights reserved.
//

import Carbon

protocol HotKeyServiceType {
  func register()
  func unregister()
}

final class HotKeyService: HotKeyServiceType {
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

  struct UserData {
    let popoverController: PopoverControllerType
  }

  private let installEventHandler: InstallEventHandler
  private let registerEventHotKey: RegisterEventHotKey
  private let unregisterEventHotKey: UnregisterEventHotKey
  private let userDefaultsService: UserDefaultsServiceType
  private(set) var userData: UserData

  private var eventHandler: EventHandlerRef?
  private var eventHotKey: EventHotKeyRef?


  // MARK: Initializing

  init(
    installEventHandler: @escaping InstallEventHandler,
    registerEventHotKey: @escaping RegisterEventHotKey,
    unregisterEventHotKey: @escaping UnregisterEventHotKey,
    userDefaultsService: UserDefaultsServiceType,
    popoverController: PopoverControllerType
  ) {
    self.installEventHandler = installEventHandler
    self.registerEventHotKey = registerEventHotKey
    self.unregisterEventHotKey = unregisterEventHotKey
    self.userDefaultsService = userDefaultsService
    self.userData = UserData(popoverController: popoverController)
  }


  // MARK: Registering Hot Key

  func register() {
    self.installHander()
    self.registerHotKey()
  }

  private func installHander() {
    guard self.eventHandler == nil else { return }
    let eventTarget = GetApplicationEventTarget()
    var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
    _ = self.installEventHandler(eventTarget, HotKeyService.handler, 1, &eventType, &self.userData, &self.eventHandler)
  }

  private func registerHotKey() {
    guard self.eventHotKey == nil else { return }
    let keyBinding = self.keyBinding()
    let hotKeyModifiers = self.keyModifiers(from: keyBinding)
    let hotKeyID = EventHotKeyID(signature: fourCharCode("a", "l", "l", "k"), id: 0)
    let eventTarget = GetApplicationEventTarget()
    _ = self.registerEventHotKey(UInt32(keyBinding.keyCode), hotKeyModifiers, hotKeyID, eventTarget, 0, &self.eventHotKey)
  }


  // MARK: Unregistering Hot Key

  func unregister() {
    _ = self.unregisterEventHotKey(self.eventHotKey)
  }


  // MARK: Handler

  static let handler: EventHandlerUPP = { eventHandlerCall, event, userData in
    userData?.assumingMemoryBound(to: UserData.self).pointee.popoverController.open()
    return noErr
  }


  // MARK: Utils

  private func keyBinding() -> KeyBinding {
    if let dictionary = self.userDefaultsService.value(forKey: .keyBinding) {
      return KeyBinding(dictionary: dictionary)
    }
    let keyBinding = KeyBinding()
    keyBinding.option = true
    keyBinding.command = true
    keyBinding.keyCode = 49 // space
    self.userDefaultsService.set(value: keyBinding.toDictionary(), forKey: .keyBinding)
    return keyBinding
  }

  private func keyModifiers(from keyBinding: KeyBinding) -> UInt32 {
    var hotKeyModifiers = 0
    if keyBinding.shift {
      hotKeyModifiers += shiftKey
    }
    if keyBinding.option {
      hotKeyModifiers += optionKey
    }
    if keyBinding.control {
      hotKeyModifiers += controlKey
    }
    if keyBinding.command {
      hotKeyModifiers += cmdKey
    }
    return UInt32(hotKeyModifiers)
  }
}
