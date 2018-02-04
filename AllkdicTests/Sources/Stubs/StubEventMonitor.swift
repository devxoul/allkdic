//
//  EventMonitorType.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 04/02/2018.
//  Copyright © 2018 Allkdic. All rights reserved.
//

import AppKit
import Stubber
@testable import Allkdic

final class StubEventMonitor: EventMonitorType {
  static func addGlobalMonitorForEvents(matching mask: NSEvent.EventTypeMask, handler block: @escaping (NSEvent) -> Void) -> Any? {
    return Stubber.invoke(addGlobalMonitorForEvents, args: (mask, escaping(block)), default: nil)
  }

  static func addLocalMonitorForEvents(matching mask: NSEvent.EventTypeMask, handler block: @escaping (NSEvent) -> NSEvent?) -> Any? {
    return Stubber.invoke(addLocalMonitorForEvents, args: (mask, escaping(block)), default: nil)
  }
}
