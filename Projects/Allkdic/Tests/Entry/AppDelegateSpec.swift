//
//  AppDelegateSpec.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 2020/05/04.
//

import Testing
@testable import Allkdic

final class AppDelegateSpec: QuickSpec {
  override func spec() {
    func createAppDelegate(
      analyticsHelper: AnalyticsHelperStub = .init(),
      preferenceService: PreferenceServiceStub = .init(),
      hotKeyService: HotKeyServiceStub = .init(),
      statusItemControllerFactory: StatusItemController.Factory = .dummy(),
      popoverControllerFactory: PopoverController.Factory = .dummy()
    ) -> AppDelegate {
      let appDelegate = AppDelegate(dependency: .init(
        analyticsHelper: analyticsHelper,
        preferenceService: preferenceService,
        hotKeyService: hotKeyService,
        statusItemControllerFactory: statusItemControllerFactory,
        popoverControllerFactory: popoverControllerFactory
      ))
      return appDelegate
    }

    describe("analytics reporting") {
      it("starts on application launch") {
        // given
        let analyticsHelper = AnalyticsHelperStub()
        let appDelegate = createAppDelegate(analyticsHelper: analyticsHelper)

        // when
        appDelegate.applicationDidFinishLaunching(Notification(name: .init(rawValue: "Test")))

        // then
        let executions = Stubber.executions(analyticsHelper.beginPeriodicReporting)
        expect(executions).to(haveCount(1))
      }

      it("logs application close on termination") {
        // given
        let analyticsHelper = AnalyticsHelperStub()
        let appDelegate = createAppDelegate(analyticsHelper: analyticsHelper)

        // when
        appDelegate.applicationWillTerminate(Notification(name: .init(rawValue: "Test")))

        // then
        let executions = Stubber.executions(analyticsHelper.handleApplicationWillClose)
        expect(executions).to(haveCount(1))
      }
    }

    describe("hot key registration") {
      context("if there is no saved key binding") {
        it("registers with the default key binding on application launch") {
          // given
          let preferenceService = PreferenceServiceStub()
          let hotKeyService = HotKeyServiceStub()
          let appDelegate = createAppDelegate(
            preferenceService: preferenceService,
            hotKeyService: hotKeyService
          )

          // when
          appDelegate.applicationDidFinishLaunching(Notification(name: .init(rawValue: "Test")))

          // then
          let executions = Stubber.executions(hotKeyService.register)
          expect(executions.first?.arguments) == KeyBinding.default
        }
      }

      context("if there is a saved key binding") {
        it("registers with the saved key binding on application launch") {
          // given
          let preferenceService = PreferenceServiceStub()
          let expectedKeyBinding = KeyBinding(keyCode: 12, shift: true, control: false, option: false, command: true)
          preferenceService.set(expectedKeyBinding, forKey: .hotKey)

          let hotKeyService = HotKeyServiceStub()
          let appDelegate = createAppDelegate(
            preferenceService: preferenceService,
            hotKeyService: hotKeyService
          )

          // when
          appDelegate.applicationDidFinishLaunching(Notification(name: .init(rawValue: "Test")))

          // then
          let executions = Stubber.executions(hotKeyService.register)
          expect(executions.first?.arguments) == expectedKeyBinding
        }
      }
    }

    describe("popover") {
      it("creates a status item controller and a popover controller on application launch") {
        // given
        let appDelegate = createAppDelegate()

        // when
        appDelegate.applicationDidFinishLaunching(Notification(name: .init(rawValue: "Test")))

        // then
        expect(appDelegate.testables[\.popoverController]).toNot(beNil())
      }
    }
  }
}
