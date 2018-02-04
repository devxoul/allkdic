//
//  PopoverType.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 04/02/2018.
//  Copyright © 2018 Allkdic. All rights reserved.
//

import AppKit

protocol PopoverType: class {
  var contentViewController: NSViewController? { get set }
  var isShown: Bool { get }

  func show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge)
  func close()
}

extension NSPopover: PopoverType {
}
