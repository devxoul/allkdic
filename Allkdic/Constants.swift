import Cocoa

enum BundleInfo {
  static let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
  static let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
  static let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
}

@objc class UserDefaultsKey: NSObject {
  @objc class var ignoreApplicationFolderWarning: String { "AKIgnoreApplicationFolder" }
  @objc class var hotKey: String { "AllkdicSettingKeyHotKey" }
  @objc class var selectedDictionaryName: String { "SelectedDictionaryName" }
}

extension Notification.Name {
  static let hotKeyDidChange = Notification.Name("hotKeyDidChange")
  static let popoverDidOpen = Notification.Name("popoverDidOpen")
}
