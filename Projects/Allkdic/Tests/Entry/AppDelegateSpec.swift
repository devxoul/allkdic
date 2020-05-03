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
      analyticsHelper: AnalyticsHelperStub = .init()
    ) -> AppDelegate {
      let appDelegate = AppDelegate(dependency: .init(
        analyticsHelper: analyticsHelper
      ))
      return appDelegate
    }

    describe("applicationDidFinishLaunching(_:)") {
      it("starts analytics reporting") {
        // given
        let analyticsHelper = AnalyticsHelperStub()
        let appDelegate = createAppDelegate(analyticsHelper: analyticsHelper)

        // when
        appDelegate.applicationDidFinishLaunching(Notification(name: .init(rawValue: "Test")))

        // then
        let executions = Stubber.executions(analyticsHelper.beginPeriodicReporting)
        expect(executions).to(haveCount(1))
      }
    }

    describe("applicationWillTerminate(_:)") {
      it("logs application close to analytics helper") {
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
  }
}
