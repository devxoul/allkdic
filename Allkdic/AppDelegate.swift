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
import SwiftUI

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
  @objc static private(set) var shared: AppDelegate!

  private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
  private let popover = NSPopover()
  private var aboutWindow: NSWindow?
  private var eventMonitor: Any?

  func applicationDidFinishLaunching(_ notification: Notification) {
    AppDelegate.shared = self
    setupStatusItem()
    setupPopover()
    setupEventMonitor()
    AKHotKeyManager.registerHotKey()
  }

  func applicationWillTerminate(_ notification: Notification) {
    UserDefaults.standard.synchronize()
    if let monitor = eventMonitor {
      NSEvent.removeMonitor(monitor)
    }
  }

  private func setupStatusItem() {
    let icon = NSImage(named: "statusicon_default")
    icon?.isTemplate = true
    statusItem.button?.image = icon
    statusItem.button?.target = self
    statusItem.button?.action = #selector(togglePopover)
    statusItem.button?.focusRingType = .none
    statusItem.button?.setButtonType(.pushOnPushOff)
  }

  private func setupPopover() {
    let contentView = MenuBarContentView()
    popover.contentViewController = NSHostingController(rootView: contentView)
    popover.contentSize = NSSize(width: 420, height: 580)
    popover.behavior = .transient
  }

  private func setupEventMonitor() {
    eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseUp, .leftMouseDown]) { [weak self] _ in
      self?.closePopover()
    }
  }

  @objc func togglePopover() {
    if popover.isShown {
      closePopover()
    } else {
      openPopover()
    }
  }

  @objc func openPopover() {
    guard let button = statusItem.button else { return }
    statusItem.button?.state = .on
    NSApp.activate(ignoringOtherApps: true)
    popover.show(relativeTo: .zero, of: button, preferredEdge: .maxY)
  }

  @objc func closePopover() {
    guard popover.isShown else { return }
    statusItem.button?.state = .off
    popover.close()
  }

  @objc func openAboutWindow() {
    closePopover()
    if aboutWindow == nil {
      let aboutView = AboutView()
      aboutWindow = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 340, height: 420),
        styleMask: [.titled, .closable, .fullSizeContentView],
        backing: .buffered,
        defer: false
      )
      aboutWindow?.title = gettext("about")
      aboutWindow?.titlebarAppearsTransparent = true
      aboutWindow?.isMovableByWindowBackground = true
      aboutWindow?.center()
      aboutWindow?.contentView = NSHostingView(rootView: aboutView)
    }
    aboutWindow?.makeKeyAndOrderFront(nil)
    NSApp.activate(ignoringOtherApps: true)
  }
}
