//
//  UserDefaultsProtocol.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 2020/05/05.
//

import Foundation

protocol UserDefaultsProtocol {
  func object(forKey defaultName: String) -> Any?
  func set(_ value: Any?, forKey defaultName: String)
}

extension UserDefaults: UserDefaultsProtocol {
}

protocol UserDefaultsStorable {
}

extension String: UserDefaultsStorable {}
extension Array: UserDefaultsStorable where Element: UserDefaultsStorable {}
extension Dictionary: UserDefaultsStorable where Key == String, Value: UserDefaultsStorable {}
extension Data: UserDefaultsStorable {}
extension Int: UserDefaultsStorable {}
extension Float: UserDefaultsStorable {}
extension Double: UserDefaultsStorable {}
extension Bool: UserDefaultsStorable {}
extension URL: UserDefaultsStorable {}
