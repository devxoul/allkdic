//
//  StubStatusItem.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 04/02/2018.
//  Copyright © 2018 Allkdic. All rights reserved.
//

import AppKit
@testable import Allkdic

final class StubStatusItem: StatusItemType {
  var image: NSImage?
  var target: AnyObject?
  var action: Selector?
  let button: NSStatusBarButton? = NSStatusBarButton()
}
