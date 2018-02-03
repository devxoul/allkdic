//
//  UserDefaultsServiceSpec.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 04/02/2018.
//  Copyright © 2018 Allkdic. All rights reserved.
//

import Nimble
import Quick
import Stubber
@testable import Allkdic

extension UserDefaultsKey {
  static var test: Key<String> { return "testKey" }
}

final class UserDefaultsServiceSpec: QuickSpec {
  override func spec() {
    var defaults: StubUserDefaults!
    var service: UserDefaultsService!

    beforeEach {
      defaults = StubUserDefaults()
      service = UserDefaultsService(defaults: defaults)
    }

    describe("value(forKey:)") {
      it("executes defaults.object(forKey:)") {
        // when
        _ = service.value(forKey: .test)

        // then
        let executions = Stubber.executions(defaults.object)
        expect(executions).to(haveCount(1))
        expect(executions.safe[0]?.arguments) == "testKey"
      }
    }

    describe("set(value:forKey:)") {
      it("executes defaults.set(value:forKey:)") {
        // when
        _ = service.set(value: "Hello", forKey: .test)

        // then
        let executions = Stubber.executions(defaults.set)
        expect(executions).to(haveCount(1))
        expect(executions.safe[0]?.arguments.0 as? String) == "Hello"
        expect(executions.safe[0]?.arguments.1) == "testKey"
      }
    }
  }
}
