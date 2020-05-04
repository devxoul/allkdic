//
//  PreferenceServiceStub.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 2020/05/05.
//

@testable import Allkdic

typealias PreferenceServiceStub = PreferenceService

extension PreferenceServiceStub {
  convenience init() {
    self.init(userDefaults: UserDefaultsStub())
  }
}
