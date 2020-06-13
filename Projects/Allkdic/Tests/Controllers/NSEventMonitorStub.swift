//
//  NSEventMonitorStub.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 2020/06/14.
//

import AppKit
import Stubber
@testable import Allkdic

final class NSEventMonitorStub: NSEventMonitorProtocol {
  @discardableResult
  static func addGlobalMonitorForEvents(matching mask: NSEvent.EventTypeMask, handler block: @escaping (NSEvent) -> Void) -> Any? {
    return Stubber.invoke(addGlobalMonitorForEvents, args: escaping(mask, block), default: nil)
  }

  @discardableResult
  static func addLocalMonitorForEvents(matching mask: NSEvent.EventTypeMask, handler block: @escaping (NSEvent) -> NSEvent?) -> Any? {
    return Stubber.invoke(addLocalMonitorForEvents, args: escaping(mask, block), default: nil)
  }
}
