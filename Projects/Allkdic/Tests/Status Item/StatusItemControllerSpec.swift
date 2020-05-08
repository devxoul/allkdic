//
//  StatusItemControllerSpec.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 2020/05/09.
//

import Pure
import Testing
@testable import Allkdic

final class StatusItemControllerSpec: QuickSpec {
  override func spec() {
    func createController(
      statusBar: NSStatusBar = .system
    ) -> StatusItemController {
      let factory = StatusItemController.Factory(dependency: .init(
        statusBar: statusBar
      ))
      return factory.create()
    }

    describe("creating status item") {
      it("creates and installs a new status item when initialized") {
        // given
        let statusBar = NSStatusBar.system
        let controller = createController(statusBar: statusBar)

        // then
        let expectedStatusItem = controller.statusItem
        expect(statusBar.statusItems).to(contain(expectedStatusItem))
      }
    }

    describe("status item") {
      var statusItem: NSStatusItem!

      beforeEach {
        let controller = createController()
        statusItem = controller.statusItem
      }

      it("has variable length") {
        expect(statusItem.length) == NSStatusItem.variableLength
      }

      it("has a template image") {
        expect(statusItem.image).toNot(beNil())
        expect(statusItem.image?.name()) == "statusicon_default"
        expect(statusItem.image?.isTemplate) == true
      }

      describe("button") {
        it("has no focus ring") {
          expect(statusItem.button?.focusRingType) == NSFocusRingType.none
        }
      }
    }

    context("handler") {
      it("executes handler on action trigger") {
        // given
        let controller = createController()

        var handlerExecutionCount = 0
        controller.handler = { handlerExecutionCount += 1 }

        // when
        if let target = controller.statusItem.target, let action = controller.statusItem.action {
          _ = target.perform(action)
        }

        // then
        expect(handlerExecutionCount) == 1
      }
    }
  }
}

extension Factory where Module == StatusItemController {
  static func dummy() -> Factory {
    return .init(dependency: .init(
      statusBar: .system
    ))
  }
}
