import Foundation
import AmplitudeSwift

final class AnalyticsHelper: @unchecked Sendable {
  static let shared = AnalyticsHelper()

  private let amplitude: Amplitude

  private init() {
    amplitude = Amplitude(configuration: Configuration(
      apiKey: "501194a85de24840f1a3a6b81fa62870",
      defaultTracking: DefaultTrackingOptions(
        sessions: true,
        appLifecycles: true
      )
    ))
    setUserProperties()
  }

  private func setUserProperties() {
    let identify = Identify()
    identify.set(property: "App Version", value: BundleInfo.version)
    identify.set(property: "App Build", value: BundleInfo.build)
    amplitude.identify(identify: identify)
  }

  func updatePreferredDictionary(_ dictionary: DictionaryType) {
    let identify = Identify()
    identify.set(property: "Preferred Dictionary", value: dictionary.name)
    amplitude.identify(identify: identify)
  }
}

extension AnalyticsHelper {
  func trackAppOpened() {
    amplitude.track(eventType: "App Opened", eventProperties: [
      "Dictionary": DictionaryType.selectedDictionary.name
    ])
  }

  func trackAppClosed() {
    amplitude.track(eventType: "App Closed")
  }

  func trackSearchSubmitted(dictionary: DictionaryType) {
    amplitude.track(eventType: "Search Submitted", eventProperties: [
      "Dictionary": dictionary.name
    ])
  }

  func trackDictionarySwitched(from previous: DictionaryType, to current: DictionaryType) {
    amplitude.track(eventType: "Dictionary Switched", eventProperties: [
      "Previous Dictionary": previous.name,
      "New Dictionary": current.name
    ])
    updatePreferredDictionary(current)
  }

  func trackHotkeyUpdated() {
    amplitude.track(eventType: "Hotkey Updated")
  }

  func trackUpdateChecked() {
    amplitude.track(eventType: "Update Checked")
  }

  func trackGitHubViewed() {
    amplitude.track(eventType: "GitHub Viewed")
  }

  func trackPreferencesOpened() {
    amplitude.track(eventType: "Preferences Opened")
  }

  func trackAboutOpened() {
    amplitude.track(eventType: "About Opened")
  }
}
