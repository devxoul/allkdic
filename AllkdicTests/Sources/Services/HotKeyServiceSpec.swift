//
//  HotKeyService.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 04/02/2018.
//  Copyright © 2018 Allkdic. All rights reserved.
//

import Carbon
import Nimble
import Quick
import Stubber
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
    var installEventHandlerExecutions: [InstallEventHandlerArgument]!
    var registerEventHotKeyExecutions: [RegisterEventHotKeyArgument]!
    var unregisterEventHotKeyExecutions: [UnregisterEventHotKeyArgument]!
    var defaults: StubUserDefaults!
    var popoverController: StubPopoverController!
    var service: HotKeyService!

    beforeEach {
      installEventHandlerExecutions = []
      registerEventHotKeyExecutions = []
      unregisterEventHotKeyExecutions = []
      defaults = StubUserDefaults()
      popoverController = StubPopoverController()
      service = HotKeyService(
        installEventHandler: {
          installEventHandlerExecutions.append(($0, $1, $2, $3, $4, $5))
          $5?.pointee = EventHandlerRef(bitPattern: 1)
          return 0
        },
        registerEventHotKey: {
          registerEventHotKeyExecutions.append(($0, $1, $2, $3, $4, $5))
          $5?.pointee = EventHotKeyRef(bitPattern: 1)
          return 0
        },
        unregisterEventHotKey: {
          unregisterEventHotKeyExecutions.append($0)
          return 0
        },
        userDefaultsService: UserDefaultsService(defaults: defaults),
        popoverController: popoverController
      )
    }

    describe("register()") {
      context("when the handler is not installed") {
        it("installs a keyboard event handler") {
          // when
          service.register()

          // then
          expect(installEventHandlerExecutions).to(haveCount(1))
        }
      }

      context("when the handler is already installed") {
        it("doesn't install a keyboard event handler") {
          // given
          service.register()
          installEventHandlerExecutions.removeAll()

          // when
          service.register()

          // then
          expect(installEventHandlerExecutions).to(haveCount(0))
        }
      }

      context("when the hot key is not registered") {
        context("when there is a saved key binding") {
          it("registers an event hot key with the saved key binding") {
            // given
            Stubber.register(defaults.object) { _ in
              return ["keyCode": 10, "shift": 0, "control": 1, "option": 1, "command": 0]
            }

            // when
            service.register()

            // then
            expect(registerEventHotKeyExecutions).to(haveCount(1))
            expect(registerEventHotKeyExecutions.safe[0]?.inHotKeyCode) == 10
            expect(registerEventHotKeyExecutions.safe[0]?.inHotKeyModifiers) == UInt32(controlKey + optionKey)
          }
        }

        context("when there is not a saved key binding") {
          it("registers an event hot key with a default key binding") {
            // given
            Stubber.register(defaults.object) { _ in nil }

            // when
            service.register()

            // then
            expect(registerEventHotKeyExecutions).to(haveCount(1))
            expect(registerEventHotKeyExecutions.safe[0]?.inHotKeyCode) == 49 // space
            expect(registerEventHotKeyExecutions.safe[0]?.inHotKeyModifiers) == UInt32(optionKey + cmdKey)
          }
        }
      }

      context("when the hot key is already registered") {
        it("doesn't register an event hot key") {
          // given
          service.register()
          registerEventHotKeyExecutions.removeAll()

          // when
          service.register()

          // then
          expect(registerEventHotKeyExecutions).to(haveCount(0))
        }
      }
    }

    describe("unregister()") {
      it("unregisters event hot key") {
        // when
        service.unregister()

        // then
        expect(unregisterEventHotKeyExecutions).to(haveCount(1))
      }
    }

    describe("handler") {
      it("opens a popover controller") {
        // given
        var userData = service.userData

        // when
        _ = HotKeyService.handler(nil, nil, &userData)

        // then
        let executions = Stubber.executions(popoverController.open)
        expect(executions).to(haveCount(1))
      }
    }
  }
}
