//
//  StatusItemController.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 2020/05/09.
//

import AppKit
import Pure

final class StatusItemController: FactoryModule {
  struct Dependency {
    let statusBar: NSStatusBar
  }

  private let dependency: Dependency
  let statusItem: NSStatusItem
  var handler: (() -> Void)?

  init(dependency: Dependency, payload: Payload) {
    self.dependency = dependency
    self.statusItem = self.dependency.statusBar.statusItem(withLength: NSStatusItem.variableLength)
    self.configureStatusItem()
    self.configureButton()
  }

  private func configureStatusItem() {
    let icon = NSImage(named: "statusicon_default")
    icon?.isTemplate = true
    self.statusItem.image = icon
    self.statusItem.target = self
    self.statusItem.action = #selector(statusItemHandler)
  }

  private func configureButton() {
    guard let button = self.statusItem.button else { return }
    button.focusRingType = .none
    button.setButtonType(.pushOnPushOff)
  }

  @objc private func statusItemHandler() {
    self.handler?()
  }
}
