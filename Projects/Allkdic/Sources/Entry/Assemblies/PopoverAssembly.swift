//
//  PopoverAssembly.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 2020/05/09.
//

import AppKit
import Swinject

final class PopoverAssembly: Assembly {
  func assemble(container: Container) {
    container.register(PopoverController.Factory.self, dependency: PopoverController.Dependency.init)
  }
}
