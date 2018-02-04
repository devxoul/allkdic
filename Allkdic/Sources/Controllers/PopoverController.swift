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

import SimpleCocoaAnalytics

private let _sharedInstance = PopoverController()

protocol PopoverControllerType {
  func open()
}

open class PopoverController: NSObject, PopoverControllerType {
  private let statusItem: StatusItemType// = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
  private let popover: PopoverType
  private let eventMonitor: EventMonitorType.Type
  private let analyticsHelper: AnalyticsHelperType

  fileprivate var statusButton: NSButton {
    return nil as NSButton!
  }

  @objc internal let contentViewController = ContentViewController()
  internal let preferenceWindowController = PreferenceWindowController()
  internal let aboutWindowController = AboutWindowController()


  @discardableResult
  @objc open class func sharedInstance() -> PopoverController {
    return _sharedInstance
  }

  init(
    statusItem: StatusItemType,
    popover: PopoverType,
    eventMonitor: EventMonitorType.Type,
    analyticsHelper: AnalyticsHelperType
  ) {
    self.statusItem = statusItem
    self.popover = popover
    self.eventMonitor = eventMonitor
    self.analyticsHelper = analyticsHelper
    super.init()
    self.configureStatusItem()
    self.configurePopover()
    self.addEventMonitors()
  }

  private func configureStatusItem() {
    let icon = NSImage(named: NSImage.Name(rawValue: "statusicon_default"))
    icon?.isTemplate = true
    self.statusItem.image = icon
    self.statusItem.target = self
    self.statusItem.action = #selector(self.open)
    self.statusItem.button?.focusRingType = .none
    self.statusItem.button?.setButtonType(.pushOnPushOff)
  }

  private func configurePopover() {
    self.popover.contentViewController = self.contentViewController
  }

  private func addEventMonitors() {
    _ = self.eventMonitor.addGlobalMonitorForEvents(matching: [.leftMouseUp, .leftMouseDown]) { [weak self] _ in
      self?.close()
    }
    _ = self.eventMonitor.addLocalMonitorForEvents(matching: .keyDown) { event in
      self.handleKeyCode(event.keyCode, flags: event.modifierFlags, windowNumber: event.windowNumber)
      return event
    }
  }

  public override init() {
    self.statusItem = nil as StatusItemType!
    self.popover = nil as PopoverType!
    self.eventMonitor = NSEvent.self
    self.analyticsHelper = nil as AnalyticsHelperType!
    super.init()
  }

  @objc open func open() {
    guard !self.popover.isShown else {
      self.close()
      return
    }
    guard let statusItemButton = self.statusItem.button else { return }

    statusItemButton.state = .on
    // NSApp.activate(ignoringOtherApps: true)
    self.popover.show(relativeTo: .zero, of: statusItemButton, preferredEdge: .maxY)

//    self.contentViewController.updateHotKeyLabel()
//    self.contentViewController.focusOnTextArea()
//
//    AnalyticsHelper.sharedInstance().recordScreen(withName: "AllkdicWindow")
//    AnalyticsHelper.sharedInstance().recordCachedEvent(
//      withCategory: AnalyticsCategory.allkdic,
//      action: AnalyticsAction.open,
//      label: nil,
//      value: nil
//    )
  }

  open func close() {
    guard self.popover.isShown else { return }
    self.statusItem.button?.state = .off
    self.popover.close()
    self.analyticsHelper.recordCachedEvent(
      withCategory: AnalyticsCategory.allkdic,
      action: AnalyticsAction.close,
      label: nil,
      value: nil
    )
  }

  open func handleKeyCode(_ keyCode: UInt16, flags: NSEvent.ModifierFlags, windowNumber: Int) {
    let keyBinding = KeyBinding(keyCode: Int(keyCode), flags: Int(flags.rawValue))

    if let window = NSApp.window(withWindowNumber: windowNumber) {
      if ["NSStatusBarWindow", "_NSPopoverWindow"].contains(type(of: window).className()) {
        self.contentViewController.handleKeyBinding(keyBinding)
      } else if let windowController = window.windowController as? PreferenceWindowController {
        windowController.handleKeyBinding(keyBinding)
      }
    }
  }
}
