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

extension Notification.Name {
  static let hotKeyDidChange = Notification.Name("hotKeyDidChange")
}
