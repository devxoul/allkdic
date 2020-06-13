//
//  NSPopoverStub.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 2020/06/14.
//

import AppKit
import Stubber
@testable import Allkdic

final class NSPopoverStub: NSPopoverProtocol {
  var contentViewController: NSViewController?

  private(set) var isShown: Bool = false

  func show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge) {
    self.isShown = true
    Stubber.invoke(show, args: (positioningRect, positioningView, preferredEdge), default: Void())
  }

  func close() {
    self.isShown = false
    Stubber.invoke(close, args: (), default: Void())
  }
}
