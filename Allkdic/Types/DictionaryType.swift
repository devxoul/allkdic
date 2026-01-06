import Cocoa

public enum DictionaryType: String, Hashable, CaseIterable {

  case Naver = "Naver"
  case Daum = "Daum"

  static var allTypes: [DictionaryType] {
    return [.Naver, .Daum]
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
    }
  }

  public var URLString: String {
    switch self {
    case .Naver: return "https://en.dict.naver.com/#/mini/main"
    case .Daum: return "https://small.dic.daum.net/top/search.do?dic=all"
    }
  }

  public var URLPattern: String {
    switch self {
    case .Naver: return "[a-z]+(?=\\.naver\\.com)"
    case .Daum: return "(?<=[?&]dic=)[a-z]+"
    }
  }

  public var inputFocusingScript: String {
    switch self {
    case .Naver: return "ac_input.focus(); ac_input.select()"
    case .Daum: return "q.focus(); q.select()"
    }
  }

  public var customCSS: String? {
    switch self {
    case .Naver:
      return """
        .Ngnb {
          display: none !important;
        }
        """
    case .Daum:
      return nil
    }
  }

}
