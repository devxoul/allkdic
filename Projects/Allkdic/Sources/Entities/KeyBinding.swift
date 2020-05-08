//
//  KeyBinding.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 2020/05/07.
//

import Foundation

struct KeyBinding: Equatable {
  var keyCode: Int
  var shift: Bool
  var control: Bool
  var option: Bool
  var command: Bool

  static let `default` = KeyBinding(keyCode: 49, shift: false, control: false, option: true, command: true)
}

extension KeyBinding: Codable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.keyCode = try container.decode(Int.self, forKey: .keyCode)
    self.shift = try container.decode(forKey: .shift)
    self.control = try container.decode(forKey: .control)
    self.option = try container.decode(forKey: .option)
    self.command = try container.decode(forKey: .command)
  }

  enum CodingKeys: String, CodingKey {
    case keyCode
    case shift
    case control
    case option
    case command
  }
}

private extension KeyedDecodingContainer {
  func decode(forKey key: Key) throws -> Bool {
    if let boolValue = try? self.decode(Bool.self, forKey: key) {
      return boolValue
    }
    if let intValue = try? self.decode(Int.self, forKey: key) {
      return intValue != 0
    }
    throw DecodingError.typeMismatch(Bool.self, DecodingError.Context(codingPath: [key], debugDescription: "Cannot decode Bool"))
  }
}
