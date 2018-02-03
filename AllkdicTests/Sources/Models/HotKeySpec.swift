//
//  HotKeySpec.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 04/02/2018.
//  Copyright © 2018 Allkdic. All rights reserved.
//

import Carbon
import Nimble
import Quick
@testable import Allkdic

final class HotKeySpec: QuickSpec {
  override func spec() {
    describe("init(json:)") {
      context("when the given json is a legacy one") {
        // given
        let json: [String: Any] = ["keyCode": 51, "shift": 1, "control": 0, "option": 1, "command": 0]

        // when
        let hotKey = try? HotKey(json: json)

        // then
        expect(hotKey).toNot(beNil())
        expect(hotKey?.code) == 51
        expect(hotKey?.shift) == true
        expect(hotKey?.control) == false
        expect(hotKey?.option) == true
        expect(hotKey?.command) == false
      }

      context("when the given json is a new one") {
        // given
        let json: [String: Any] = ["code": 45, "shift": false, "control": true, "option": false, "command": true]

        // when
        let hotKey = try? HotKey(json: json)

        // then
        expect(hotKey).toNot(beNil())
        expect(hotKey?.code) == 45
        expect(hotKey?.shift) == false
        expect(hotKey?.control) == true
        expect(hotKey?.option) == false
        expect(hotKey?.command) == true
      }
    }

    describe("json()") {
      it("returns a json dictionary") {
        // given
        let hotKey = HotKey(code: 30, shift: true, control: true, option: false, command: false)

        // when
        let json = (try? hotKey.json()) as? [String: Any]

        // then
        expect(json).to(haveCount(5))
        expect(json?["code"] as? Int) == 30
        expect(json?["shift"] as? Bool) == true
        expect(json?["control"] as? Bool) == true
        expect(json?["option"] as? Bool) == false
        expect(json?["command"] as? Bool) == false
      }
    }

    describe("cocoaKeyModifiers") {
      it("returns a valid modifier") {
        expect(HotKey(code: 0, shift: true, control: true, option: true, command: true).cocoaKeyModifiers) == [.shift, .control, .option, .command]
        expect(HotKey(code: 0, shift: false, control: false, option: false, command: false).cocoaKeyModifiers) == []
      }
    }

    describe("carbonKeyModifiers") {
      it("returns a valid modifier") {
        expect(HotKey(code: 0, shift: true, control: true, option: true, command: true).carbonKeyModifiers) == UInt32(shiftKey + controlKey + optionKey + cmdKey)
        expect(HotKey(code: 0, shift: false, control: false, option: false, command: false).carbonKeyModifiers) == 0
      }
    }

    describe("string(from:)") {
      expect(HotKey.string(from: 49)) == "SPACE"
    }

    describe("code(from:)") {
      expect(HotKey.code(from: "SPACE")) == 49
    }
  }
}
