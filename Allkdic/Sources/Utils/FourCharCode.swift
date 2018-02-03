//
//  FourCharCode.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 04/02/2018.
//  Copyright © 2018 Allkdic. All rights reserved.
//

import Foundation

func fourCharCode(_ a: Character, _ b: Character, _ c: Character, _ d: Character) -> FourCharCode {
  return [a, b, c, d]
    .reversed()
    .enumerated()
    .map { i, char in char.unicodeScalars.first!.value << (i * 8) }
    .reduce(0, |)
}
