//
//  StubHotKeyService.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 04/02/2018.
//  Copyright © 2018 Allkdic. All rights reserved.
//

import Stubber
@testable import Allkdic

final class StubHotKeyService: HotKeyServiceType {
  func register() {
    return Stubber.invoke(register, args: (), default: Void())
  }

  func unregister() {
    return Stubber.invoke(unregister, args: (), default: Void())
  }
}
