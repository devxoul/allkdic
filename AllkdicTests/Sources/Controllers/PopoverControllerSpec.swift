//
//  PopoverControllerSpec.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 04/02/2018.
//  Copyright © 2018 Allkdic. All rights reserved.
//

import Nimble
import Quick
import Stubber
@testable import Allkdic

final class PopoverControllerSpec: QuickSpec {
  override func spec() {
    func createController(
      statusItem: StatusItemType = StubStatusItem(),
      popover: PopoverType = StubPopover(),
      eventMonitor: EventMonitorType.Type = StubEventMonitor.self,
      analyticsHelper: AnalyticsHelperType = StubAnalyticsHelper()
    ) -> PopoverController {
      return .init(
        statusItem: statusItem,
        popover: popover,
        eventMonitor: eventMonitor,
        analyticsHelper: analyticsHelper
      )
    }

    describe("init()") {
      it("configures a status item") {
        // given
        let statusItem = StubStatusItem()
        let controller = createController(statusItem: statusItem)

        // then
        expect(statusItem.image).toNot(beNil())
        expect(statusItem.target) === controller
        expect(statusItem.action) == #selector(controller.open)
        expect(statusItem.button?.focusRingType) == NSFocusRingType.none
      }

      it("sets popover's content view controller") {
        // given
        let popover = StubPopover()
        let controller = createController(popover: popover)

        // then
        expect(popover.contentViewController) === controller.contentViewController
      }

      it("adds global event monitor") {
        // given
        let eventMonitor = StubEventMonitor.self
        _ = createController(eventMonitor: eventMonitor)

        // then
        let executions = Stubber.executions(eventMonitor.addGlobalMonitorForEvents)
        expect(executions).to(haveCount(1))
        expect(executions.safe[0]?.arguments.0) == [.leftMouseUp, .leftMouseDown]
      }

      it("adds local event monitor") {
        // given
        let eventMonitor = StubEventMonitor.self
        _ = createController(eventMonitor: eventMonitor)

        // then
        let executions = Stubber.executions(eventMonitor.addLocalMonitorForEvents)
        expect(executions).to(haveCount(1))
        expect(executions.safe[0]?.arguments.0) == .keyDown
      }
    }

    describe("open()") {
      context("when it is already open") {
        it("closes popover") {
          // given
          let popover = StubPopover()
          popover.isShown = true
          let controller = createController(popover: popover)

          // when
          controller.open()

          // then
          let executions = Stubber.executions(popover.close)
          expect(executions).to(haveCount(1))
        }
      }

      context("when it is not open") {
        var popover: StubPopover!
        beforeEach {
          popover = StubPopover()
          popover.isShown = false
        }

        it("opens popover from status item button") {
          // given
          let statusItem = StubStatusItem()
          let controller = createController(statusItem: statusItem, popover: popover)

          // when
          controller.open()

          // then
          let executions = Stubber.executions(popover.show)
          expect(executions).to(haveCount(1))
          expect(executions.safe[0]?.arguments.1) === statusItem.button
          expect(executions.safe[0]?.arguments.2) == .maxY
        }

        it("sets button state to on") {
          // given
          let statusItem = StubStatusItem()
          let controller = createController(statusItem: statusItem, popover: popover)

          // when
          controller.open()

          // then
          expect(statusItem.button?.state) == .on
        }
      }
    }

    describe("close()") {
      context("when it is not open") {
        it("doesn't close popover") {
          // given
          let popover = StubPopover()
          popover.isShown = false
          let controller = createController(popover: popover)

          // when
          controller.close()

          // then
          let executions = Stubber.executions(popover.close)
          expect(executions).to(haveCount(0))
        }
      }

      context("when it is open") {
        var popover: StubPopover!
        beforeEach {
          popover = StubPopover()
          popover.isShown = true
        }

        it("closes popover") {
          // given
          let controller = createController(popover: popover)

          // when
          controller.close()

          // then
          let executions = Stubber.executions(popover.close)
          expect(executions).to(haveCount(1))
        }

        it("sets button state to off") {
          // given
          let statusItem = StubStatusItem()
          let controller = createController(statusItem: statusItem, popover: popover)

          // when
          controller.close()

          // then
          expect(statusItem.button?.state) == .off
        }

        it("records close event") {
          // given
          let analyticsHelper = StubAnalyticsHelper()
          let controller = createController(popover: popover, analyticsHelper: analyticsHelper)

          // when
          controller.close()

          // then
          let executions = Stubber.executions(analyticsHelper.recordCachedEvent)
          expect(executions).to(haveCount(1))
          expect(executions.safe[0]?.arguments.0) == AnalyticsCategory.allkdic
          expect(executions.safe[0]?.arguments.1) == AnalyticsAction.close
          expect(executions.safe[0]?.arguments.2).to(beNil())
          expect(executions.safe[0]?.arguments.3).to(beNil())
        }
      }
    }
  }
}
