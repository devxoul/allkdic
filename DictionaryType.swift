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

public enum DictionaryType: String {

    case Naver = "Naver"
    case Daum = "Daum"


    static var allTypes: [DictionaryType] {
        return [.Naver, .Daum]
    }

    static var selectedDictionary: DictionaryType {
        get {
            if let name = NSUserDefaults.standardUserDefaults().stringForKey(UserDefaultsKey.SelectedDictionaryName),
               let dict = DictionaryType(name: name) {
                return dict
            }
            self.selectedDictionary = .Naver
            return .Naver
        }
        set {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setValue(newValue.name, forKey: UserDefaultsKey.SelectedDictionaryName)
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
        case .Naver: return "네이버 사전"
        case .Daum: return "다음 사전"
        }
    }

    public var URLString: String {
        switch self {
        case .Naver: return "http://endic.naver.com/popManager.nhn?m=miniPopMain"
        case .Daum: return "http://small.dic.daum.net/"
        }
    }

    public var URLPattern: String {
        switch self {
        case .Naver: return "[a-z]+(?=\\.naver\\.com)"
        case .Daum: return "(?<=[?&]dic=)[a-z]+"
        }
    }

}
