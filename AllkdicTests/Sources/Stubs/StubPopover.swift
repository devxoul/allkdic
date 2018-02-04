//
//  StubPopover.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 04/02/2018.
//  Copyright © 2018 Allkdic. All rights reserved.
//

import AppKit
import Stubber
@testable import Allkdic

final class StubPopover: PopoverType {
  var contentViewController: NSViewController?
  var isShown: Bool = false

  func show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge) {
    return Stubber.invoke(show, args: (positioningRect, positioningView, preferredEdge), default: Void())
  }

  func close() {
    return Stubber.invoke(close, args: (), default: Void())
  }
}
