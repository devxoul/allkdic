//
//  NSAppStub.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 2020/06/14.
//

import AppKit
import Stubber
@testable import Allkdic

final class NSAppStub: NSAppActivatable {
  func activate(ignoringOtherApps flag: Bool) {
    return Stubber.invoke(activate, args: flag, default: Void())
  }
}
