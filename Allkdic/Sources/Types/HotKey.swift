//
//  HotKey.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 04/02/2018.
//  Copyright © 2018 Allkdic. All rights reserved.
//

import AppKit
import Carbon

struct HotKey: Model {
  typealias Code = UInt16

  let code: Code
  let shift: Bool
  let control: Bool
  let option: Bool
  let command: Bool

  init(code: Code, shift: Bool = false, control: Bool = false, option: Bool = false, command: Bool = false) {
    self.code = code
    self.shift = shift
    self.control = control
    self.option = option
    self.command = command
  }

  var cocoaKeyModifiers: NSEvent.ModifierFlags {
    var value: NSEvent.ModifierFlags = []
    if self.shift { value.insert(.shift) }
    if self.option { value.insert(.option) }
    if self.control { value.insert(.control) }
    if self.command { value.insert(.command) }
    return value
  }

  var carbonKeyModifiers: UInt32 {
    var value = 0
    if self.shift { value += shiftKey }
    if self.option { value += optionKey }
    if self.control { value += controlKey }
    if self.command { value += cmdKey }
    return UInt32(value)
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.code = try (try? container.decode(Code.self, forKey: .keyCode)) ?? (container.decode(Code.self, forKey: .code))
    self.shift = try (try? container.decode(Bool.self, forKey: .shift)) ?? Bool(container.decode(Int.self, forKey: .shift) == 1)
    self.option = try (try? container.decode(Bool.self, forKey: .option)) ?? Bool(container.decode(Int.self, forKey: .option) == 1)
    self.control = try (try? container.decode(Bool.self, forKey: .control)) ?? Bool(container.decode(Int.self, forKey: .control) == 1)
    self.command = try (try? container.decode(Bool.self, forKey: .command)) ?? Bool(container.decode(Int.self, forKey: .command) == 1)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.code, forKey: .code)
    try container.encode(self.shift, forKey: .shift)
    try container.encode(self.option, forKey: .option)
    try container.encode(self.control, forKey: .control)
    try container.encode(self.control, forKey: .control)
    try container.encode(self.command, forKey: .command)
  }

  enum CodingKeys: String, CodingKey {
    case keyCode // legacy support
    case code
    case shift
    case control
    case option
    case command
  }
}

extension HotKey {
  static func string(from code: Code) -> String? {
    return keyMap[Int(code)]
  }

  static func code(from string: String) -> Code? {
    return (keyMap.first { $0.value == string }?.key).map(Code.init)
  }
}
