import Nimble
import Quick
import Stubber
@testable import Allkdic

final class AppDelegateSpec: QuickSpec {
  override func spec() {
    func createAppDelegate(
      analyticsHelper: StubAnalyticsHelper = .init(),
      hotKeyService: StubHotKeyService = .init()
    ) -> AppDelegate {
      let appDelegate = AppDelegate(dependency: .init(
        analyticsHelper: analyticsHelper,
        hotKeyService: hotKeyService
      ))
      return appDelegate
    }

    describe("applicationDidFinishLaunching(_:)") {
      it("starts analytics reporting") {
        // given
        let analyticsHelper = StubAnalyticsHelper()
        let appDelegate = createAppDelegate(analyticsHelper: analyticsHelper)

        // when
        appDelegate.applicationDidFinishLaunching(Notification(name: .init(rawValue: "Test")))

        // then
        let executions = Stubber.executions(analyticsHelper.beginPeriodicReporting)
        expect(executions).to(haveCount(1))
      }

      it("registers a hot key") {
        // given
        let hotKeyService = StubHotKeyService()
        let appDelegate = createAppDelegate(hotKeyService: hotKeyService)

        // when
        appDelegate.applicationDidFinishLaunching(Notification(name: .init(rawValue: "Test")))

        // then
        let executions = Stubber.executions(hotKeyService.register)
        expect(executions).to(haveCount(1))
      }
    }

    describe("applicationWillTerminate(_:)") {
      it("logs application close to analytics helper") {
        // given
        let analyticsHelper = StubAnalyticsHelper()
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
