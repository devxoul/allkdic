/*
 The MIT License (MIT)

 Copyright (c) 2013-2014 Suyeol Jeon (http://xoul.kr)

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
*/

struct BundleInfo {
    static let Version = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as String
    static let Build = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as String
    static let BundleName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as String
}

@objc class UserDefaultsKey {
    class var IgnoreApplicationFolderWarning: String { return "AKIgnoreApplicationFolder" }
    class var HotKey: String { return "AllkdicSettingKeyHotKey" }
    class var SelectedDictionaryName: String { return "SelectedDictionaryName" }
}


// MARK: - Dictionary

struct DictionaryName {
    static let Naver = "Naver"
    static let Daum = "Daum"
}

struct DictionaryInfoKey {
    static let Name = "Name"
    static let Title = "Title"
    static let URL = "URL"
    static let URLPattern = "URLPattern"
}

let DictionaryInfo = [
    [
        DictionaryInfoKey.Name: DictionaryName.Naver,
        DictionaryInfoKey.Title: "네이버 사전",
        DictionaryInfoKey.URL: "http://endic.naver.com/popManager.nhn?m=miniPopMain",
        DictionaryInfoKey.URLPattern: "[a-z]+(?=\\.naver\\.com)",
    ],
    [
        DictionaryInfoKey.Name: DictionaryName.Daum,
        DictionaryInfoKey.Title: "다음 사전",
        DictionaryInfoKey.URL: "http://small.dic.daum.net/",
        DictionaryInfoKey.URLPattern: "(?<=[?&]dic=)[a-z]+",
    ]
]


// MARK: - Google Analytics

struct AnalyticsCategory {
    static let Allkdic = "Allkdic"
    static let Preference = "Preference"
    static let About = "About"
}

struct AnalyticsAction {
    static let Open = "Open"
    static let Close = "Close"
    static let Dictionary = "Dictionary" // Use `DictionaryName` as Label
    static let Search = "Search"
    static let UpdateHotKey = "UpdateHotKey"
    static let CheckForUpdate = "CheckForUpdate"
    static let ViewOnGitHub = "ViewOnGitHub"
}

struct AnalyticsLabel {
    static let English = "English"
    static let Korean = "Korean"
    static let Hanja = "Hanja"
    static let Japanese = "Japanese"
    static let Chinese = "Chinese"
    static let French = "French"
    static let Russian = "Russian"
}
