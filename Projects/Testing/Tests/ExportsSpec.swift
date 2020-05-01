//
//  ExportsSpec.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 2020/05/01.
//

import Testing

final class ExportsSpec: QuickSpec {
  override func spec() {
    it("automatically imports Quick and Nimble") {
      expect(true).to(beTruthy())
    }
  }
}
