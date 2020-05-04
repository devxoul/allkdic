//
//  PreferenceService.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 2020/05/05.
//

import Foundation

protocol PreferenceServiceProtocol {
  func value<T>(forKey key: PreferenceKey<T>) -> T?
  func set<T>(_ value: T?, forKey key: PreferenceKey<T>)
}

final class PreferenceService: PreferenceServiceProtocol {
  private let userDefaults: UserDefaultsProtocol

  init(userDefaults: UserDefaultsProtocol) {
    self.userDefaults = userDefaults
  }

  func value<T>(forKey key: PreferenceKey<T>) -> T? {
    guard let rawValue = self.userDefaults.object(forKey: key.rawValue) else { return nil }
    if let decodedValue: T = self.decodedValue(rawValue) {
      return decodedValue
    } else {
      return rawValue as? T
    }
  }

  private func decodedValue<T: Decodable>(_ rawValue: Any) -> T? {
    switch rawValue {
    case let jsonData as Data:
      return try? JSONDecoder().decode(T.self, from: jsonData)

    case let jsonDictionary as [String: Any]:
      guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonDictionary) else { return nil }
      return try? JSONDecoder().decode(T.self, from: jsonData)

    default:
      return nil
    }
  }

  func set<T>(_ value: T?, forKey key: PreferenceKey<T>) {
    if let encodedValue = try? JSONEncoder().encode(value) {
      self.userDefaults.set(encodedValue, forKey: key.rawValue)
    } else {
      self.userDefaults.set(value, forKey: key.rawValue)
    }
  }
}

struct PreferenceKey<T: Codable>: RawRepresentable {
  let rawValue: String
}

extension PreferenceKey: ExpressibleByStringLiteral {
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

extension PreferenceKey {
}
