//
//  FourCharCode.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 2020/05/05.
//

import Foundation

struct FourCharCode {
  let rawValue: UInt32

  init(_ a: Character, _ b: Character, _ c: Character, _ d: Character) {
    self.rawValue = [a, b, c, d].lazy
      .reversed()
      .enumerated()
      .map { i, char in char.unicodeScalars.first!.value << (i * 8) }
      .reduce(0, |)
  }
}
