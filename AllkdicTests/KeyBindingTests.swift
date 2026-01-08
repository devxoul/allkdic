@testable import Allkdic
import XCTest

final class KeyBindingTests: XCTestCase {
  // MARK: - description

  func test_description_withAllModifiers() {
    let binding = KeyBinding(keyCode: 49, shift: true, control: true, option: true, command: true)
    XCTAssertEqual(binding.description, "Shift + Control + Option + Command + Space")
  }

  func test_description_withOptionCommandSpace() {
    let binding = KeyBinding(keyCode: 49, option: true, command: true)
    XCTAssertEqual(binding.description, "Option + Command + Space")
  }

  func test_description_withSingleModifier() {
    let binding = KeyBinding(keyCode: 0, command: true)
    XCTAssertEqual(binding.description, "Command + A")
  }

  func test_description_withNoModifiers() {
    let binding = KeyBinding(keyCode: 36)
    XCTAssertEqual(binding.description, "Return")
  }

  func test_description_withUnknownKeyCode() {
    let binding = KeyBinding(keyCode: 9999, command: true)
    XCTAssertEqual(binding.description, "Command")
  }

  // MARK: - init(keyCode:flags:)

  func test_initWithFlags_controlFlag() {
    // Control is bit 0
    let binding = KeyBinding(keyCode: 49, flags: 1 << 0)
    XCTAssertTrue(binding.control)
    XCTAssertFalse(binding.shift)
    XCTAssertFalse(binding.option)
    XCTAssertFalse(binding.command)
  }

  func test_initWithFlags_shiftFlag() {
    // Shift is bit 1
    let binding = KeyBinding(keyCode: 49, flags: 1 << 1)
    XCTAssertTrue(binding.shift)
    XCTAssertFalse(binding.control)
    XCTAssertFalse(binding.option)
    XCTAssertFalse(binding.command)
  }

  func test_initWithFlags_commandFlag() {
    // Command is bit 3
    let binding = KeyBinding(keyCode: 49, flags: 1 << 3)
    XCTAssertTrue(binding.command)
    XCTAssertFalse(binding.control)
    XCTAssertFalse(binding.shift)
    XCTAssertFalse(binding.option)
  }

  func test_initWithFlags_optionFlag() {
    // Option is bit 5
    let binding = KeyBinding(keyCode: 49, flags: 1 << 5)
    XCTAssertTrue(binding.option)
    XCTAssertFalse(binding.control)
    XCTAssertFalse(binding.shift)
    XCTAssertFalse(binding.command)
  }

  func test_initWithFlags_multipleFlags() {
    // Option (bit 5) + Command (bit 3) = 0b101000 = 40
    let binding = KeyBinding(keyCode: 49, flags: (1 << 5) | (1 << 3))
    XCTAssertTrue(binding.option)
    XCTAssertTrue(binding.command)
    XCTAssertFalse(binding.control)
    XCTAssertFalse(binding.shift)
  }

  func test_initWithFlags_allFlags() {
    // Control (0) + Shift (1) + Command (3) + Option (5)
    let flags = (1 << 0) | (1 << 1) | (1 << 3) | (1 << 5)
    let binding = KeyBinding(keyCode: 49, flags: flags)
    XCTAssertTrue(binding.control)
    XCTAssertTrue(binding.shift)
    XCTAssertTrue(binding.command)
    XCTAssertTrue(binding.option)
  }

  func test_initWithFlags_zeroFlags() {
    let binding = KeyBinding(keyCode: 49, flags: 0)
    XCTAssertFalse(binding.control)
    XCTAssertFalse(binding.shift)
    XCTAssertFalse(binding.command)
    XCTAssertFalse(binding.option)
  }

  // MARK: - init?(dictionary:)

  func test_initWithDictionary_withIntValues() {
    let dict: [String: Any] = [
      "keyCode": 49,
      "shift": 1,
      "control": 0,
      "option": 1,
      "command": 1,
    ]
    let binding = KeyBinding(dictionary: dict)
    XCTAssertNotNil(binding)
    XCTAssertEqual(binding?.keyCode, 49)
    XCTAssertTrue(binding!.shift)
    XCTAssertFalse(binding!.control)
    XCTAssertTrue(binding!.option)
    XCTAssertTrue(binding!.command)
  }

  func test_initWithDictionary_withBoolValues() {
    let dict: [String: Any] = [
      "keyCode": 49,
      "shift": true,
      "control": false,
      "option": true,
      "command": true,
    ]
    let binding = KeyBinding(dictionary: dict)
    XCTAssertNotNil(binding)
    XCTAssertEqual(binding?.keyCode, 49)
    XCTAssertTrue(binding!.shift)
    XCTAssertFalse(binding!.control)
    XCTAssertTrue(binding!.option)
    XCTAssertTrue(binding!.command)
  }

  func test_initWithDictionary_withMixedValues() {
    let dict: [String: Any] = [
      "keyCode": 49,
      "shift": 1,
      "control": false,
      "option": true,
      "command": 0,
    ]
    let binding = KeyBinding(dictionary: dict)
    XCTAssertNotNil(binding)
    XCTAssertTrue(binding!.shift)
    XCTAssertFalse(binding!.control)
    XCTAssertTrue(binding!.option)
    XCTAssertFalse(binding!.command)
  }

  func test_initWithDictionary_withNilDictionary() {
    let binding = KeyBinding(dictionary: nil)
    XCTAssertNil(binding)
  }

  func test_initWithDictionary_withEmptyDictionary() {
    let binding = KeyBinding(dictionary: [:])
    XCTAssertNotNil(binding)
    XCTAssertEqual(binding?.keyCode, 0)
    XCTAssertFalse(binding!.shift)
    XCTAssertFalse(binding!.control)
    XCTAssertFalse(binding!.option)
    XCTAssertFalse(binding!.command)
  }

  // MARK: - toDictionary()

  func test_toDictionary() {
    let binding = KeyBinding(keyCode: 49, shift: true, control: false, option: true, command: true)
    let dict = binding.toDictionary()
    XCTAssertEqual(dict["keyCode"], 49)
    XCTAssertEqual(dict["shift"], 1)
    XCTAssertEqual(dict["control"], 0)
    XCTAssertEqual(dict["option"], 1)
    XCTAssertEqual(dict["command"], 1)
  }

  func test_toDictionary_roundTrip() {
    let original = KeyBinding(keyCode: 49, shift: true, control: true, option: true, command: true)
    let dict = original.toDictionary()
    let restored = KeyBinding(dictionary: dict)
    XCTAssertEqual(original, restored)
  }

  // MARK: - keyStringFormKeyCode / keyCodeFormKeyString

  func test_keyStringFormKeyCode_validCodes() {
    XCTAssertEqual(KeyBinding.keyStringFormKeyCode(49), "SPACE")
    XCTAssertEqual(KeyBinding.keyStringFormKeyCode(36), "RETURN")
    XCTAssertEqual(KeyBinding.keyStringFormKeyCode(0), "a")
    XCTAssertEqual(KeyBinding.keyStringFormKeyCode(122), "F1")
  }

  func test_keyStringFormKeyCode_invalidCode() {
    XCTAssertNil(KeyBinding.keyStringFormKeyCode(9999))
  }

  func test_keyCodeFormKeyString_validStrings() {
    XCTAssertEqual(KeyBinding.keyCodeFormKeyString("SPACE"), 49)
    XCTAssertEqual(KeyBinding.keyCodeFormKeyString("RETURN"), 36)
    XCTAssertEqual(KeyBinding.keyCodeFormKeyString("a"), 0)
    XCTAssertEqual(KeyBinding.keyCodeFormKeyString("F1"), 122)
  }

  func test_keyCodeFormKeyString_invalidString() {
    XCTAssertEqual(KeyBinding.keyCodeFormKeyString("INVALID"), -1)
  }

  // MARK: - Equatable / Hashable

  func test_equatable() {
    let binding1 = KeyBinding(keyCode: 49, option: true, command: true)
    let binding2 = KeyBinding(keyCode: 49, option: true, command: true)
    let binding3 = KeyBinding(keyCode: 49, option: true, command: false)
    XCTAssertEqual(binding1, binding2)
    XCTAssertNotEqual(binding1, binding3)
  }

  func test_hashable() {
    let binding1 = KeyBinding(keyCode: 49, option: true, command: true)
    let binding2 = KeyBinding(keyCode: 49, option: true, command: true)
    var set = Set<KeyBinding>()
    set.insert(binding1)
    set.insert(binding2)
    XCTAssertEqual(set.count, 1)
  }
}
