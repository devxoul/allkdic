import Cocoa

struct BundleInfo {
  static let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
  static let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
  static let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
}

@objc class UserDefaultsKey: NSObject {
  @objc class var ignoreApplicationFolderWarning: String { return "AKIgnoreApplicationFolder" }
  @objc class var hotKey: String { return "AllkdicSettingKeyHotKey" }
  @objc class var selectedDictionaryName: String { return "SelectedDictionaryName" }
}


// MARK: - Google Analytics

struct AnalyticsCategory {
  static let allkdic = "Allkdic"
  static let preference = "Preference"
  static let about = "About"
}

struct AnalyticsAction {
  static let open = "Open"
  static let close = "Close"
  static let dictionary = "Dictionary" // Use `DictionaryName` as Label
  static let search = "Search"
  static let updateHotKey = "UpdateHotKey"
  static let checkForUpdate = "CheckForUpdate"
  static let viewOnGitHub = "ViewOnGitHub"
}

struct AnalyticsLabel {
  static let english = "English"
  static let korean = "Korean"
  static let hanja = "Hanja"
  static let japanese = "Japanese"
  static let chinese = "Chinese"
  static let french = "French"
  static let russian = "Russian"
  static let spanish = "Spanish"
}

extension Notification.Name {
  static let hotKeyDidChange = Notification.Name("hotKeyDidChange")
}
