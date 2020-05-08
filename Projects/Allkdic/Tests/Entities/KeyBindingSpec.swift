//
//  KeyBindingSpec.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 2020/05/07.
//

import Testing
@testable import Allkdic

final class KeyBindingSpec: QuickSpec {
  override func spec() {
    describe("default") {
      it("is a combination of option, command and space") {
        let keyBinding = KeyBinding.default
        expect(keyBinding.keyCode) == 49
        expect(keyBinding.shift) == false
        expect(keyBinding.control) == false
        expect(keyBinding.option) == true
        expect(keyBinding.command) == true
      }
    }

    describe("Codable") {
      it("can be decoded from a dictionary with bool values") {
        let json = ["keyCode": 10, "shift": false, "control": true, "option": true, "command": false]
        let data = try! JSONSerialization.data(withJSONObject: json)
        let keyBinding = try? JSONDecoder().decode(KeyBinding.self, from: data)
        expect(keyBinding).toNot(beNil())
        expect(keyBinding?.keyCode) == 10
        expect(keyBinding?.shift) == false
        expect(keyBinding?.control) == true
        expect(keyBinding?.option) == true
        expect(keyBinding?.command) == false
      }

      it("can be decoded from a dictionary with int values") {
        let json = ["keyCode": 20, "shift": 1, "control": 1, "option": 0, "command": 0]
        let data = try! JSONSerialization.data(withJSONObject: json)
        let keyBinding = try? JSONDecoder().decode(KeyBinding.self, from: data)
        expect(keyBinding).toNot(beNil())
        expect(keyBinding?.keyCode) == 20
        expect(keyBinding?.shift) == true
        expect(keyBinding?.control) == true
        expect(keyBinding?.option) == false
        expect(keyBinding?.command) == false
      }

      it("can be encoded into a dictionary") {
        let keyBinding = KeyBinding(
          keyCode: 48,
          shift: true,
          control: false,
          option: false,
          command: true
        )

        let data = try! JSONEncoder().encode(keyBinding)
        let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        expect(json).toNot(beNil())
        expect(json?.count) == 5
        expect(json?["keyCode"] as? Int) == 48
        expect(json?["shift"] as? Int) == 1
        expect(json?["control"] as? Int) == 0
        expect(json?["option"] as? Int) == 0
        expect(json?["command"] as? Int) == 1
      }
    }
  }
}
