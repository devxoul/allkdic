//
//  StubUserDefaults.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 04/02/2018.
//  Copyright © 2018 Allkdic. All rights reserved.
//

import Stubber
@testable import Allkdic

final class StubUserDefaults: UserDefaultsType {
  func object(forKey defaultName: String) -> Any? {
    return Stubber.invoke(object, args: defaultName, default: nil)
  }

  func set(_ value: Any?, forKey defaultName: String) {
    return Stubber.invoke(set, args: (value, defaultName), default: Void())
  }

  @discardableResult
  func synchronize() -> Bool {
    return Stubber.invoke(synchronize, args: (), default: false)
  }
}
