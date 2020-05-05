//
//  FourCharCodeSpec.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 2020/05/05.
//

import Testing
@testable import Allkdic

final class FourCharCodeSpec: QuickSpec {
  override func spec() {
    describe("rawValue") {
      it("returns valid value") {
        expect(FourCharCode("a", "a", "a", "a").rawValue) == [97, (97 << 8), (97 << 16), (97 << 24)].reduce(0, |)
        expect(FourCharCode("a", "b", "c", "d").rawValue) == [100, (99 << 8), (98 << 16), (97 << 24)].reduce(0, |)
        expect(FourCharCode("a", "l", "l", "k").rawValue) == 1634495595
      }
    }
  }
}
