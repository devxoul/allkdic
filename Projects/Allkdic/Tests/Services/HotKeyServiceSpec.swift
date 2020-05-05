//
//  HotKeyServiceSpec.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 2020/05/04.
//

import Carbon
import Testing
@testable import Allkdic

final class HotKeyServiceSpec: QuickSpec {
  typealias InstallEventHandlerArgument = (
    inTarget: EventTargetRef?,
    inHandler: Carbon.EventHandlerUPP?,
    inNumTypes: Int,
    inList: UnsafePointer<EventTypeSpec>?,
    inUserData: UnsafeMutableRawPointer?,
    outRef: UnsafeMutablePointer<EventHandlerRef?>?
  )
  typealias RegisterEventHotKeyArgument = (
    inHotKeyCode: UInt32,
    inHotKeyModifiers: UInt32,
    inHotKeyID: EventHotKeyID,
    inTarget: EventTargetRef?,
    inOptions: OptionBits,
    outRef: UnsafeMutablePointer<EventHotKeyRef?>?
  )
  typealias UnregisterEventHotKeyArgument = EventHotKeyRef?

  override func spec() {
    func createService(
      installEventHandler: @escaping HotKeyService.InstallEventHandler = { _, _, _, _, _, _ in -1 },
      registerEventHotKey: @escaping HotKeyService.RegisterEventHotKey = { _, _, _, _, _, _ in -1 },
      unregisterEventHotKey: @escaping HotKeyService.UnregisterEventHotKey = { _ in -1 },
      notificationCenter: NotificationCenter = .init()
    ) -> HotKeyService {
      return HotKeyService(
        installEventHandler: installEventHandler,
        registerEventHotKey: registerEventHotKey,
        unregisterEventHotKey: unregisterEventHotKey,
        notificationCenter: notificationCenter
      )
    }

    describe("register()") {
      it("installs a keyboard event handler") {
        // given
        var installEventHandlerExecutionCount = 0
        let service = createService(installEventHandler: { _, _, _, _, _, _ in
          installEventHandlerExecutionCount += 1
          return 0
        })

        // when
        service.register(keyBinding: KeyBinding(keyCode: 0, shift: false, control: false, option: false, command: false))

        // then
        expect(installEventHandlerExecutionCount) == 1
      }

      it("registers an event hot key with the saved key binding") {
        // given
        var registerEventHotKeyExecutions: [RegisterEventHotKeyArgument] = []
        let service = createService(registerEventHotKey: {
          registerEventHotKeyExecutions.append(($0, $1, $2, $3, $4, $5))
          return 0
        })

        // when
        let keyBinding = KeyBinding(keyCode: 10, shift: false, control: true, option: true, command: false)
        service.register(keyBinding: keyBinding)

        // then
        expect(registerEventHotKeyExecutions).to(haveCount(1))
        expect(registerEventHotKeyExecutions.first?.inHotKeyCode) == 10
        expect(registerEventHotKeyExecutions.first?.inHotKeyModifiers) == UInt32(Carbon.controlKey + Carbon.optionKey)
      }
    }

    describe("unregister()") {
      it("unregisters event hot key") {
        // given
        var unregisterEventHotKeyExecutionCount = 0
        let service = createService(unregisterEventHotKey: { _ in
          unregisterEventHotKeyExecutionCount += 1
          return 0
        })

        // when
        service.unregister()

        // then
        expect(unregisterEventHotKeyExecutionCount) == 1
      }
    }

    context("when receives hot key event") {
      it("opens a popover controller") {
        // given
        let notificationCenter = NotificationCenter()
        let service = createService(notificationCenter: notificationCenter)

        var notificationObservationCount = 0
        let observer = notificationCenter.addObserver(forName: .globalHotKeyPressed, object: nil, queue: nil) { _ in
          notificationObservationCount += 1
        }

        struct UserData {
          let notificationCenter: NotificationCenter
        }
        var userData = UserData(notificationCenter: notificationCenter)
        _ = service.testables.hotKeyHandler(nil, nil, &userData)

        // then
        expect(notificationObservationCount) == 1

        // clean up
        notificationCenter.removeObserver(observer)
      }
    }
  }
}
