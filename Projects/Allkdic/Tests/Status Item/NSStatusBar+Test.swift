//
//  NSStatusBar+Test.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 2020/05/09.
//

import AppKit

extension NSStatusBar {
  var statusItems: [NSStatusItem]? {
    let pointerArray = self.value(forKey: "statusItems") as? NSPointerArray
    return pointerArray?.allObjects as? [NSStatusItem]
  }
}
