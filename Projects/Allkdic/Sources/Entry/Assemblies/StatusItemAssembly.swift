//
//  StatusItemAssembly.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 2020/05/09.
//

import AppKit
import Swinject

final class StatusItemAssembly: Assembly {
  func assemble(container: Container) {
    container.register(NSStatusBar.self) { _ in NSStatusBar.system }
    container.register(StatusItemController.Factory.self, dependency: StatusItemController.Dependency.init)
  }
}
