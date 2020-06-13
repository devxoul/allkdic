//
//  NSAppActivatable.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 2020/06/14.
//

import AppKit

protocol NSAppActivatable {
  func activate(ignoringOtherApps flag: Bool)
}

extension NSApplication: NSAppActivatable {
}
