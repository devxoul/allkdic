import Foundation

public struct KeyBinding: Codable, Equatable, Hashable, Sendable {
  public var keyCode: Int = 0
  public var shift: Bool = false
  public var control: Bool = false
  public var option: Bool = false
  public var command: Bool = false

  public var description: String {
    var keys = [String]()
    if self.shift { keys.append("Shift") }
    if self.control { keys.append("Control") }
    if self.option { keys.append("Option") }
    if self.command { keys.append("Command") }

    if let keyString = KeyBinding.keyStringFormKeyCode(self.keyCode) {
      keys.append(keyString.capitalized)
    }

    return keys.joined(separator: " + ")
  }

  public init() {}

  public init(keyCode: Int, shift: Bool = false, control: Bool = false, option: Bool = false, command: Bool = false) {
    self.keyCode = keyCode
    self.shift = shift
    self.control = control
    self.option = option
    self.command = command
  }

  public init(keyCode: Int, flags: Int) {
    self.keyCode = keyCode
    for i in 0...6 {
      if flags & (1 << i) != 0 {
        if i == 0 { self.control = true }
        else if i == 1 { self.shift = true }
        else if i == 3 { self.command = true }
        else if i == 5 { self.option = true }
      }
    }
  }

  public init?(dictionary: [AnyHashable: Any]?) {
    guard let dict = dictionary else { return nil }
    self.keyCode = dict["keyCode"] as? Int ?? 0
    self.shift = dict["shift"] as? Int == 1 || dict["shift"] as? Bool == true
    self.control = dict["control"] as? Int == 1 || dict["control"] as? Bool == true
    self.option = dict["option"] as? Int == 1 || dict["option"] as? Bool == true
    self.command = dict["command"] as? Int == 1 || dict["command"] as? Bool == true
  }

  public func toDictionary() -> [String: Int] {
    return [
      "keyCode": keyCode,
      "shift": shift ? 1 : 0,
      "control": control ? 1 : 0,
      "option": option ? 1 : 0,
      "command": command ? 1 : 0
    ]
  }

  public static func keyStringFormKeyCode(_ keyCode: Int) -> String? {
    return keyMap[keyCode]
  }

  public static func keyCodeFormKeyString(_ string: String) -> Int {
    for (keyCode, keyString) in keyMap {
      if keyString == string {
        return keyCode
      }
    }
    return -1
  }
}
