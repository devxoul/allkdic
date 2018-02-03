//
//  UserDefaultsType.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 04/02/2018.
//  Copyright © 2018 Allkdic. All rights reserved.
//

import Foundation

protocol UserDefaultsType {
  func object(forKey defaultName: String) -> Any?
  func set(_ value: Any?, forKey defaultName: String)

  @discardableResult
  func synchronize() -> Bool
}

extension UserDefaults: UserDefaultsType {
}
