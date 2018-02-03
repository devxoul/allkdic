//
//  AllkWebView.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 04/02/2018.
//  Copyright © 2018 Allkdic. All rights reserved.
//

import WebKit

final class AllkWebView: WebView {
  override func performKeyEquivalent(with event: NSEvent) -> Bool {
    if event.modifierFlags.contains(.command) {
      switch event.keyCode {
      case HotKey.code(from: "a")!:
        self.selectAll(self)
        return true

      case HotKey.code(from: "x")!:
        self.cut(self)
        return true

      case HotKey.code(from: "c")!:
        self.copy(self)
        return true

      case HotKey.code(from: "v")!:
        self.paste(self)
        return true

      default:
        break
      }
    }
    return super.performKeyEquivalent(with: event)
  }
}
