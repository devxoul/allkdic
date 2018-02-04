//
//  StatusItemType.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 04/02/2018.
//  Copyright © 2018 Allkdic. All rights reserved.
//

import AppKit

protocol StatusItemType: class {
  var image: NSImage? { get set }
  var target: AnyObject? { get set }
  var action: Selector? { get set }
  var button: NSStatusBarButton? { get }
}

extension NSStatusItem: StatusItemType {
}
