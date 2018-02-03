// The MIT License (MIT)
//
// Copyright (c) 2013 Suyeol Jeon (http://xoul.kr)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
