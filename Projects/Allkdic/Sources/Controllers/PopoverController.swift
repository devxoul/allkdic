// The MIT License (MIT)
//
// Copyright (c) 2013 Suyeol Jeon (http://xoul.kr)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Cocoa

import Pure
import SimpleCocoaAnalytics

@objc final class PopoverController: NSObject, FactoryModule {

  // MARK: Module

  struct Dependency {
    let popoverFactory: () -> NSPopoverProtocol
    let notificationCenter: NotificationCenter
    let application: NSAppActivatable
    let eventMonitor: NSEventMonitorProtocol.Type
    let analyticsHelper: AnalyticsHelperProtocol
  }

  struct Payload {
    let statusItemController: StatusItemController
  }


  // MARK: Properties

  private let dependency: Dependency
  private let payload: Payload

  fileprivate let popover: NSPopoverProtocol

  @objc internal let contentViewController = ContentViewController()
  internal let preferenceWindowController = PreferenceWindowController()
  internal let aboutWindowController = AboutWindowController()


  @available(*, deprecated)
  @objc class func sharedInstance() -> PopoverController {
    return (nil as PopoverController?)!
  }


  // MARK: Initiaizling

  init(dependency: Dependency, payload: Payload) {
    self.dependency = dependency
    self.payload = payload
    self.popover = dependency.popoverFactory()

    super.init()
    self.configureStatusItem()
    self.configureContentViewControler()
    self.addEventMonitors()
    self.addNotificationObservers()
  }

  deinit {
    self.removeNotificationObservers()
  }

  private func configureStatusItem() {
    self.payload.statusItemController.handler = self.toggleOpen
  }

  private func configureContentViewControler() {
    self.popover.contentViewController = self.contentViewController
  }

  private func addEventMonitors() {
    self.dependency.eventMonitor.addGlobalMonitorForEvents(matching: [.leftMouseUp, .leftMouseDown]) { [weak self] _ in
      self?.close()
    }

    self.dependency.eventMonitor.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
      self?.handleKeyCode(event.keyCode, flags: event.modifierFlags, windowNumber: event.windowNumber)
      return event
    }
  }

  private func addNotificationObservers() {
    self.dependency.notificationCenter.addObserver(self, selector: #selector(toggleOpen), name: .globalHotKeyPressed, object: nil)
  }

  private func removeNotificationObservers() {
    self.dependency.notificationCenter.removeObserver(self)
  }


  // MARK: Opening and Closing

  @objc func open() {
    let statusItemButton = self.payload.statusItemController.statusItem.button!
    statusItemButton.state = .on

    self.popover.show(relativeTo: .zero, of: statusItemButton, preferredEdge: .maxY)
    self.dependency.application.activate(ignoringOtherApps: true)

    self.contentViewController.updateHotKeyLabel()
    self.contentViewController.focusOnTextArea()

    self.dependency.analyticsHelper.recordScreen(withName: "AllkdicWindow")
    self.dependency.analyticsHelper.recordCachedEvent(
      withCategory: AnalyticsCategory.allkdic,
      action: AnalyticsAction.open,
      label: nil,
      value: nil
    )
  }

  func close() {
    guard self.popover.isShown else { return }

    let statusItemButton = self.payload.statusItemController.statusItem.button!
    statusItemButton.state = .off
    self.popover.close()

    self.dependency.analyticsHelper.recordCachedEvent(
      withCategory: AnalyticsCategory.allkdic,
      action: AnalyticsAction.close,
      label: nil,
      value: nil
    )
  }

  @objc private func toggleOpen() {
    if !self.popover.isShown {
      self.open()
    } else {
      self.close()
    }
  }


  // MARK: Handling Keyboard

  func handleKeyCode(_ keyCode: UInt16, flags: NSEvent.ModifierFlags, windowNumber: Int) {
    let keyBinding = LegacyKeyBinding(keyCode: Int(keyCode), flags: Int(flags.rawValue))

    if let window = NSApp.window(withWindowNumber: windowNumber) {
      if ["NSStatusBarWindow", "_NSPopoverWindow"].contains(type(of: window).className()) {
        self.contentViewController.handleKeyBinding(keyBinding)
      } else if let windowController = window.windowController as? PreferenceWindowController {
        windowController.handleKeyBinding(keyBinding)
      }
    }
  }
}
