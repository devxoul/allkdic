import AmplitudeSwift
import Foundation

final class AnalyticsHelper: @unchecked Sendable {
  static let shared = AnalyticsHelper()

  private let amplitude: Amplitude

  private init() {
    self.amplitude = Amplitude(configuration: Configuration(
      apiKey: "501194a85de24840f1a3a6b81fa62870",
      defaultTracking: DefaultTrackingOptions(
        sessions: true,
        appLifecycles: true,
      ),
    ))
    self.setUserProperties()
  }

  private func setUserProperties() {
    let identify = Identify()
    identify.set(property: "App Version", value: BundleInfo.version)
    identify.set(property: "App Build", value: BundleInfo.build)
    self.amplitude.identify(identify: identify)
  }

  func updatePreferredDictionary(_ dictionary: DictionaryType) {
    let identify = Identify()
    identify.set(property: "Preferred Dictionary", value: dictionary.name)
    self.amplitude.identify(identify: identify)
  }
}

extension AnalyticsHelper {
  func trackSearchSubmitted(dictionary: DictionaryType) {
    self.amplitude.track(eventType: "Search Submitted", eventProperties: [
      "Dictionary": dictionary.name,
    ])
  }

  func trackDictionarySwitched(from previous: DictionaryType, to current: DictionaryType) {
    self.amplitude.track(eventType: "Dictionary Switched", eventProperties: [
      "Previous Dictionary": previous.name,
      "New Dictionary": current.name,
    ])
    self.updatePreferredDictionary(current)
  }

  func trackHotkeyUpdated() {
    self.amplitude.track(eventType: "Hotkey Updated")
  }

  func trackUpdateChecked() {
    self.amplitude.track(eventType: "Update Checked")
  }

  func trackGitHubViewed() {
    self.amplitude.track(eventType: "GitHub Viewed")
  }

  func trackPreferencesOpened() {
    self.amplitude.track(eventType: "Preferences Opened")
  }

  func trackAboutOpened() {
    self.amplitude.track(eventType: "About Opened")
  }
}
