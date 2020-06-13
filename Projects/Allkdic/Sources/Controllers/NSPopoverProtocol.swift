//
//  NSPopoverProtocol.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 2020/06/14.
//

import AppKit

protocol NSPopoverProtocol: class {
  var contentViewController: NSViewController? { get set }

  var isShown: Bool { get }

  func show(relativeTo positioningRect: NSRect, of positioningView: NSView, preferredEdge: NSRectEdge)
  func close()
}
