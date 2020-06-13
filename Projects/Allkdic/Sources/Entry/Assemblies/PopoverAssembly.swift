//
//  PopoverAssembly.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 2020/05/09.
//

import AppKit
import Swinject

final class PopoverAssembly: Assembly {
  private typealias NSPopoverFactory = () -> NSPopoverProtocol

  func assemble(container: Container) {
    container.register(PopoverController.Factory.self, dependency: PopoverController.Dependency.init)
    container.register(NSPopoverFactory.self) { _ in NSPopover.init }
    container.register(NSAppActivatable.self) { _ in NSApp }
    container.register(NSEventMonitorProtocol.Type.self) { _ in NSEvent.self }
  }
}
