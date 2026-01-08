import Cocoa

public enum DictionaryType: String, Hashable, CaseIterable {
  case Naver
  case Daum

  static var allTypes: [DictionaryType] {
    [.Naver, .Daum]
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
    rawValue
  }

  public var title: String {
    switch self {
    case .Naver: gettext("naver_dictionary")
    case .Daum: gettext("daum_dictionary")
    }
  }

  public var URLString: String {
    switch self {
    case .Naver: "https://en.dict.naver.com/#/mini/main"
    case .Daum: "https://small.dic.daum.net/top/search.do?dic=all"
    }
  }

  public var URLPattern: String {
    switch self {
    case .Naver: "[a-z]+(?=\\.naver\\.com)"
    case .Daum: "(?<=[?&]dic=)[a-z]+"
    }
  }

  public var inputFocusingScript: String {
    switch self {
    case .Naver:
      """
      var input = document.getElementById('gnb_svc_search_input');
      if (input) { input.focus(); input.select(); }
      """
    case .Daum:
      """
      var input = document.getElementById('q');
      if (input) { input.focus(); input.select(); }
      """
    }
  }

  public var customCSS: String? {
    switch self {
    case .Naver:
      """
      .Ngnb {
        display: none !important;
      }
      """
    case .Daum:
      nil
    }
  }
}
