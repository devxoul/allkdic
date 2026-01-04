// The MIT License (MIT)
//
// Copyright (c) 2015 Suyeol Jeon (http://xoul.kr)
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

public enum DictionaryType: String, Hashable, CaseIterable {

  case Naver = "Naver"
  case Daum = "Daum"
  case NaverMobile = "NaverMobile"


  static var allTypes: [DictionaryType] {
    return [.Naver, .Daum, .NaverMobile]
  }

  static var selectedDictionary: DictionaryType {
    get {
      if let name = UserDefaults.standard.string(forKey: UserDefaultsKey.selectedDictionaryName),
        let dict = DictionaryType(name: name) {
        return dict
      }
      self.selectedDictionary = .Naver
      return .Naver
    }
    set {
      let userDefaults = UserDefaults.standard
      userDefaults.setValue(newValue.name, forKey: UserDefaultsKey.selectedDictionaryName)
      userDefaults.synchronize()
    }
  }


  public init?(name: String) {
    self.init(rawValue: name)
  }


  public var name: String {
    return self.rawValue
  }

  public var title: String {
    switch self {
    case .Naver: return gettext("naver_dictionary")
    case .Daum: return gettext("daum_dictionary")
    case .NaverMobile: return gettext("naver_mobile_dictionary")
    }
  }

  public var URLString: String {
    switch self {
    case .Naver: return "http://endic.naver.com/popManager.nhn?m=miniPopMain"
    case .Daum: return "http://small.dic.daum.net/"
    case .NaverMobile: return "http://m.dic.naver.com/"
    }
  }

  public var URLPattern: String {
    switch self {
    case .Naver: return "[a-z]+(?=\\.naver\\.com)"
    case .Daum: return "(?<=[?&]dic=)[a-z]+"
    case .NaverMobile: return "(?<=m\\.)[a-z]+(?=\\.naver\\.com)"
    }
  }

  public var inputFocusingScript: String {
    switch self {
    case .Naver: return "ac_input.focus(); ac_input.select()"
    case .Daum: return "q.focus(); q.select()"
    case .NaverMobile: return "ac_input.focus(); ac_input.select()"
    }
  }

}
