//
//  EventMonitorType.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 04/02/2018.
//  Copyright © 2018 Allkdic. All rights reserved.
//

import AppKit

protocol EventMonitorType {
  @discardableResult
  static func addGlobalMonitorForEvents(matching mask: NSEvent.EventTypeMask, handler block: @escaping (NSEvent) -> Void) -> Any?

  @discardableResult
  static func addLocalMonitorForEvents(matching mask: NSEvent.EventTypeMask, handler block: @escaping (NSEvent) -> NSEvent?) -> Any?
}

extension NSEvent: EventMonitorType {
}
