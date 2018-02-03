//
//  FourCharCodeSpec.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 04/02/2018.
//  Copyright © 2018 Allkdic. All rights reserved.
//

import Nimble
import Quick
@testable import Allkdic

final class FourCharCodeSpec: QuickSpec {
  override func spec() {
    it("returns valid value") {
      expect(fourCharCode("a", "a", "a", "a")) == 97 | (97 << 8) | (97 << 16) | (97 << 24)
      expect(fourCharCode("a", "b", "c", "d")) == 100 | (99 << 8) | (98 << 16) | (97 << 24)
      expect(fourCharCode("a", "l", "l", "k")) == 1634495595
    }
  }
}
