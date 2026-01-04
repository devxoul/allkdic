import Cocoa
import SwiftUI

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
  @objc static private(set) var shared: AppDelegate!

  private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
  private let popover = NSPopover()
  private var eventMonitor: Any?

  func applicationDidFinishLaunching(_ notification: Notification) {
    AppDelegate.shared = self
    setupStatusItem()
    setupPopover()
    setupEventMonitor()
    HotKeyManager.registerHotKey()
    closeSettingsWindowIfNeeded()
  }

  func applicationWillTerminate(_ notification: Notification) {
    UserDefaults.standard.synchronize()
    if let monitor = eventMonitor {
      NSEvent.removeMonitor(monitor)
    }
  }

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }

  private func closeSettingsWindowIfNeeded() {
    DispatchQueue.main.async {
      for window in NSApp.windows where window.identifier?.rawValue == "com_apple_SwiftUI_Settings_window" {
        window.close()
      }
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
}
