//
//  HotKeyServiceStub.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 2020/05/06.
//

import Testing
@testable import Allkdic

final class HotKeyServiceStub: HotKeyServiceProtocol {
  func register(keyBinding: KeyBinding) {
    Stubber.invoke(register, args: keyBinding, default: Void())
  }

  func unregister() {
    Stubber.invoke(unregister, args: (), default: Void())
  }
}
