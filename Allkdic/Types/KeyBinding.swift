// The MIT License (MIT)
//
// Copyright (c) 2013 Suyeol Jeon (http://xoul.kr)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

private let dictionaryKeys = ["keyCode", "shift", "control", "option", "command"]

@objc public class KeyBinding: NSObject {

  @objc dynamic var keyCode: Int = 0
  @objc dynamic var shift: Bool = false
  @objc dynamic var control: Bool = false
  @objc dynamic var option: Bool = false
  @objc dynamic var command: Bool = false

  public override var description: String {
    var keys = [String]()
    if self.shift {
      keys.append("Shift")
    }
    if self.control {
      keys.append("Control")
    }
    if self.option {
      keys.append("Option")
    }
    if self.command {
      keys.append("Command")
    }

    if let keyString = type(of: self).keyStringFormKeyCode(self.keyCode) {
      keys.append(keyString.capitalized)
    }

    return keys.joined(separator: " + ")
  }

  @objc public override init() {
    super.init()
  }

  @objc public init(keyCode: Int, flags: Int) {
    super.init()
    self.keyCode = keyCode
    for i in 0...6 {
      if flags & (1 << i) != 0 {
        if i == 0 {
          self.control = true
        } else if i == 1 {
          self.shift = true
        } else if i == 3 {
          self.command = true
        } else if i == 5 {
          self.option = true
        }
      }
    }
  }

  @objc public init(dictionary: [AnyHashable: Any]?) {
    super.init()
    guard let dictionary = dictionary else { return }
    for key in dictionaryKeys {
      if let value = dictionary[key] as? Int {
        self.setValue(value, forKey: key)
      }
    }
  }

  @objc public func toDictionary() -> [String: Int] {
    var dictionary = [String: Int]()
    for key in dictionaryKeys {
      if let value = self.value(forKey: key) as? Int {
        dictionary[key] = value
      }
    }
    return dictionary
  }

  @objc public class func keyStringFormKeyCode(_ keyCode: Int) -> String? {
    return keyMap[keyCode]
  }

  @objc public class func keyCodeFormKeyString(_ string: String) -> Int {
    for (keyCode, keyString) in keyMap {
      if keyString == string {
        return keyCode
      }
    }
    return NSNotFound
  }

  public override func isEqual(_ object: Any?) -> Bool {
    guard let other = object as? KeyBinding else { return false }
    return self.keyCode == other.keyCode &&
           self.shift == other.shift &&
           self.control == other.control &&
           self.option == other.option &&
           self.command == other.command
  }

  public override var hash: Int {
    var hasher = Hasher()
    hasher.combine(keyCode)
    hasher.combine(shift)
    hasher.combine(control)
    hasher.combine(option)
    hasher.combine(command)
    return hasher.finalize()
  }
}
