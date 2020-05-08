//
//  NSEventMonitorProtocol.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 2020/05/09.
//

import AppKit

protocol NSEventMonitorProtocol {
  @discardableResult
  static func addGlobalMonitorForEvents(matching mask: NSEvent.EventTypeMask, handler block: @escaping (NSEvent) -> Void) -> Any?

  @discardableResult
  static func addLocalMonitorForEvents(matching mask: NSEvent.EventTypeMask, handler block: @escaping (NSEvent) -> NSEvent?) -> Any?
}

extension NSEvent: NSEventMonitorProtocol {
}
