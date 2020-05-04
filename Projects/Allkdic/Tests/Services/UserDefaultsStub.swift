//
//  UserDefaultsStub.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 2020/05/05.
//

import Testing
@testable import Allkdic

final class UserDefaultsStub: UserDefaults {
  init() {
    super.init(suiteName: UUID().uuidString)!
  }

  deinit {
    for key in self.dictionaryRepresentation().keys {
      self.removeObject(forKey: key)
    }
  }
}
