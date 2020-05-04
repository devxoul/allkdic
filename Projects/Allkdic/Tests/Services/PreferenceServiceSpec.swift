//
//  PreferenceServiceSpec.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 2020/05/05.
//

import Testing
@testable import Allkdic

private extension PreferenceKey {
  static var testName: PreferenceKey<String> { "testName" }
  static var testUser: PreferenceKey<User> { "testUser" }
}

final class PreferenceServiceSpec: QuickSpec {
  override func spec() {
    var userDefaults: UserDefaultsStub!
    var service: PreferenceService!

    beforeEach {
      userDefaults = UserDefaultsStub()
      service = PreferenceService(userDefaults: userDefaults)
    }

    describe("value(forKey:)") {
      it("returns the stored value") {
        let expectedName = "Suyeol Jeon"
        service.set(expectedName, forKey: .testName)

        let actualName = service.value(forKey: .testName)
        expect(actualName) == expectedName
      }

      it("returns Codable object") {
        let expectedUser = User(id: 123, name: "John Appleseed")
        service.set(expectedUser, forKey: .testUser)

        let actualUser = service.value(forKey: .testUser)
        expect(actualUser) == expectedUser
      }

      it("returns Codable object if dictionary is stored") {
        userDefaults.set(["id": 123, "name": "John Appleseed"], forKey: "testUser")

        let actualUser = service.value(forKey: .testUser)
        expect(actualUser) == User(id: 123, name: "John Appleseed")
      }
    }
  }
}

private struct User: Codable, Equatable {
  let id: Int
  let name: String
}
