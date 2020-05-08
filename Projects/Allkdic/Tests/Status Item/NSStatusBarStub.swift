//
//  NSStatusBarStub.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 2020/05/09.
//

import Testing
@testable import Allkdic

final class NSStatusBarStub: NSStatusBar {
  override func statusItem(withLength length: CGFloat) -> NSStatusItem {
    let alloc = NSStatusItem.perform(NSSelectorFromString("alloc"))!.takeRetainedValue() as! NSStatusItem

    let selector = NSSelectorFromString("_initInStatusBar:withLength:withPriority:hidden:")
    let imp = alloc.method(for: selector)

    typealias ObjcInitBlock = @convention(c) (NSStatusItem, Selector, NSStatusBar, CGFloat, Int, Bool) -> NSStatusItem
    let initializer = unsafeBitCast(imp, to: ObjcInitBlock.self)
    let statusItem = initializer(alloc, selector, self, length, 1, true)
    return statusItem
  }
}
