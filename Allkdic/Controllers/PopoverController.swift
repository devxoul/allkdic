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

@MainActor
final class PopoverController: NSObject {

  @objc static let shared = PopoverController()

  @objc class func sharedInstance() -> PopoverController {
    return shared
  }

  private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
  private var statusButton: NSButton? {
    return self.statusItem.button
  }
  private let popover = NSPopover()

  @objc let contentViewController = ContentViewController()
  let preferenceWindowController = PreferenceWindowController()
  let aboutWindowController = AboutWindowController()

  private override init() {
    super.init()
  }

  func setup() {
    let icon = NSImage(named: "statusicon_default")
    icon?.isTemplate = true
    self.statusItem.button?.image = icon
    self.statusItem.button?.target = self
    self.statusItem.button?.action = #selector(PopoverController.open)

    self.statusItem.button?.focusRingType = .none
    self.statusItem.button?.setButtonType(.pushOnPushOff)

    self.popover.contentViewController = self.contentViewController
    self.popover.contentSize = NSSize(width: 420, height: 580)

    NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseUp, .leftMouseDown]) { _ in
      self.close()
    }

    NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
      self.handleKeyCode(event.keyCode, flags: event.modifierFlags, windowNumber: event.windowNumber)
      return event
    }
  }

  @objc func open() {
    if self.popover.isShown {
      self.close()
      return
    }

    self.statusItem.button?.state = .on

    NSApp.activate(ignoringOtherApps: true)
    if let button = self.statusItem.button {
      self.popover.show(relativeTo: .zero, of: button, preferredEdge: .maxY)
    }
    self.contentViewController.updateHotKeyLabel()
    self.contentViewController.focusOnTextArea()
  }

  @objc func close() {
    if !self.popover.isShown {
      return
    }

    self.statusItem.button?.state = .off
    self.popover.close()
  }

  func handleKeyCode(_ keyCode: UInt16, flags: NSEvent.ModifierFlags, windowNumber: Int) {
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
