//
//  UserDefaultsService.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 04/02/2018.
//  Copyright © 2018 Allkdic. All rights reserved.
//

import Foundation

// MARK: - UserDefaultsKey

struct UserDefaultsKey<T>: RawRepresentable {
  typealias Key<T> = UserDefaultsKey<T>
  let rawValue: String
}

extension UserDefaultsKey: ExpressibleByStringLiteral {
  public init(unicodeScalarLiteral value: StringLiteralType) {
    self.init(rawValue: value)
  }

  public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
    self.init(rawValue: value)
  }

  public init(stringLiteral value: StringLiteralType) {
    self.init(rawValue: value)
  }
}

extension UserDefaultsKey {
  static var ignoreApplicationFolderWarning: Key<String> { return "AKIgnoreApplicationFolder" }
  static var hotKey: Key<[String: Any]> { return "AllkdicSettingKeyHotKey" }
  static var selectedDictionaryName: Key<String> { return "SelectedDictionaryName" }
}


// MARK: - UserDefaultsService

protocol UserDefaultsServiceType {
  func value<T>(forKey key: UserDefaultsKey<T>) -> T?
  func set<T>(value: T?, forKey key: UserDefaultsKey<T>)
}

final class UserDefaultsService: UserDefaultsServiceType {
  private let defaults: UserDefaultsType

  init(defaults: UserDefaultsType) {
    self.defaults = defaults
  }

  func value<T>(forKey key: UserDefaultsKey<T>) -> T? {
    return self.defaults.object(forKey: key.rawValue) as? T
  }

  func set<T>(value: T?, forKey key: UserDefaultsKey<T>) {
    self.defaults.set(value, forKey: key.rawValue)
    self.defaults.synchronize()
  }
}
