//
//  PopoverControllerSpec.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 2020/06/14.
//

import Pure
import Testing
@testable import Allkdic

final class PopoverControllerSpec: QuickSpec {
  override func spec() {
    func createController(
      popoverFactory: @escaping () -> NSPopoverStub = { .init() },
      notificationCenter: NotificationCenter = .init(),
      application: NSAppStub = .init(),
      eventMonitor: NSEventMonitorStub.Type = NSEventMonitorStub.self,
      analyticsHelper: AnalyticsHelperStub = .init(),
      statusItemController: StatusItemController = StatusItemController.Factory.dummy().create()
    ) -> PopoverController {
      let factory = PopoverController.Factory(dependency: .init(
        popoverFactory: popoverFactory,
        notificationCenter: notificationCenter,
        application: application,
        eventMonitor: eventMonitor,
        analyticsHelper: analyticsHelper
      ))
      return factory.create(payload: .init(
        statusItemController: statusItemController
      ))
    }

    context("when initialized") {
      it("sets popover content view controller") {
        // given
        let popover = NSPopoverStub()
        let controller = createController(popoverFactory: { popover })

        // then
        expect(popover.contentViewController) === controller.contentViewController
      }

      it("adds global event monitor for mouse left down and up") {
        // given
        let eventMonitor = NSEventMonitorStub.self
        let _ = createController(eventMonitor: eventMonitor)

        // then
        let executions = Stubber.executions(eventMonitor.addGlobalMonitorForEvents)
        expect(executions).to(haveCount(1))
        expect(executions.first?.arguments.0) == [.leftMouseUp, .leftMouseDown]
      }

      it("adds local event monitor for key down") {
        // TODO: adds local event monitor for key down
      }
    }

    describe("Open") {
      it("opens popover when clicks status item") {
        // given
        let popover = NSPopoverStub()
        let statusItemController = StatusItemController.Factory.dummy().create()
        let _ = createController(
          popoverFactory: { popover },
          statusItemController: statusItemController
        )

        // when
        statusItemController.handler?()

        // then
        expect(popover.isShown) == true
      }

      it("opens popover when triggers global hot key") {
        // given
        let popover = NSPopoverStub()
        let notificationCenter = NotificationCenter()
        let _ = createController(
          popoverFactory: { popover },
          notificationCenter: notificationCenter
        )

        // when
        notificationCenter.post(name: .globalHotKeyPressed, object: nil)

        // then
        expect(popover.isShown) == true
      }

      it("sets status item button on") {
        // given
        let statusItemController = StatusItemController.Factory.dummy().create()
        let controller = createController(statusItemController: statusItemController)

        // when
        controller.open()

        // then
        expect(statusItemController.statusItem.button?.state) == .on
      }

      it("shows popover from the status item button") {
        // given
        let popover = NSPopoverStub()
        let statusItemController = StatusItemController.Factory.dummy().create()
        let controller = createController(
          popoverFactory: { popover },
          statusItemController: statusItemController
        )

        // when
        controller.open()

        // then
        let executions = Stubber.executions(popover.show)
        expect(executions).to(haveCount(1))
        expect(executions.first?.arguments.1) === statusItemController.statusItem.button
      }

      it("activates app with ignoring other apps") {
        // given
        let app = NSAppStub()
        let controller = createController(application: app)

        // when
        controller.open()

        // then
        let executions = Stubber.executions(app.activate)
        expect(executions).to(haveCount(1))
        expect(executions.first?.arguments) == true
      }

      it("set a focus to search text field") {
        // TODO: set a focus to search text field
      }

      it("logs analytics screen event") {
        // given
        let analyticsHelper = AnalyticsHelperStub()
        let controller = createController(analyticsHelper: analyticsHelper)

        // when
        controller.open()

        // then
        let executions = Stubber.executions(analyticsHelper.recordScreen)
        expect(executions).to(haveCount(1))
        expect(executions.first?.arguments) == "AllkdicWindow"
      }

      it("logs analytics open event") {
        // given
        let analyticsHelper = AnalyticsHelperStub()
        let controller = createController(analyticsHelper: analyticsHelper)

        // when
        controller.open()

        // then
        let executions = Stubber.executions(analyticsHelper.recordCachedEvent)
        expect(executions).to(haveCount(1))
        expect(executions.first?.arguments.0) == AnalyticsCategory.allkdic
        expect(executions.first?.arguments.1) == AnalyticsAction.open
      }
    }

    describe("Close") {
      it("closes popover when clicks status item") {
        // given
        let popover = NSPopoverStub()
        let statusItemController = StatusItemController.Factory.dummy().create()
        let controller = createController(
          popoverFactory: { popover },
          statusItemController: statusItemController
        )
        controller.open()

        // when
        statusItemController.handler?()

        // then
        expect(popover.isShown) == false
      }

      it("closes popover when triggers global hot key") {
        // given
        let popover = NSPopoverStub()
        let notificationCenter = NotificationCenter()
        let controller = createController(
          popoverFactory: { popover },
          notificationCenter: notificationCenter
        )
        controller.open()

        // when
        notificationCenter.post(name: .globalHotKeyPressed, object: nil)

        // then
        expect(popover.isShown) == false
      }

      it("closes popover when click outside popover") {
        // given
        let popover = NSPopoverStub()
        let eventMonitor = NSEventMonitorStub.self
        var eventHandler: ((NSEvent) -> Void)?
        Stubber.register(eventMonitor.addGlobalMonitorForEvents) { _, handler in
          eventHandler = handler
        }

        let controller = createController(
          popoverFactory: { popover },
          eventMonitor: eventMonitor
        )
        controller.open()

        // when
        eventHandler?(NSEvent())

        // then
        expect(popover.isShown) == false
      }

      it("sets status item button off") {
        // given
        let statusItemController = StatusItemController.Factory.dummy().create()
        let controller = createController(statusItemController: statusItemController)
        controller.open()

        // when
        controller.close()

        // then
        expect(statusItemController.statusItem.button?.state) == .off
      }

      it("logs analytics close event") {
        // given
        let analyticsHelper = AnalyticsHelperStub()
        let controller = createController(analyticsHelper: analyticsHelper)
        controller.open()
        Stubber.clear()

        // when
        controller.close()

        // then
        let executions = Stubber.executions(analyticsHelper.recordCachedEvent)
        expect(executions).to(haveCount(1))
        expect(executions.first?.arguments.0) == AnalyticsCategory.allkdic
        expect(executions.first?.arguments.1) == AnalyticsAction.close
      }
    }
  }
}

extension Factory where Module == PopoverController {
  static func dummy() -> Factory {
    return .init(dependency: .init(
      popoverFactory: NSPopoverStub.init,
      notificationCenter: NotificationCenter(),
      application: NSAppStub(),
      eventMonitor: NSEventMonitorStub.self,
      analyticsHelper: AnalyticsHelperStub()
    ))
  }
}
