import Cocoa
import SwiftUI

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
  @objc private(set) static var shared: AppDelegate!

  private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
  private let popover = NSPopover()
  private var eventMonitor: Any?
  private var preferencesWindow: NSWindow?
  private var aboutWindow: NSWindow?

  override init() {
    super.init()
    UserDefaults.standard.set(false, forKey: "NSQuitAlwaysKeepsWindows")
  }

  func applicationDidFinishLaunching(_: Notification) {
    AppDelegate.shared = self
    self.setupStatusItem()
    self.setupPopover()
    self.setupEventMonitor()
    HotKeyManager.registerHotKey()
  }

  func applicationWillTerminate(_: Notification) {
    UserDefaults.standard.synchronize()
    if let monitor = eventMonitor {
      NSEvent.removeMonitor(monitor)
    }
  }

  func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
    false
  }

  private func setupStatusItem() {
    let icon = NSImage(named: "statusicon_default")
    icon?.isTemplate = true
    self.statusItem.button?.image = icon
    self.statusItem.button?.target = self
    self.statusItem.button?.action = #selector(self.togglePopover)
    self.statusItem.button?.focusRingType = .none
    self.statusItem.button?.setButtonType(.pushOnPushOff)
  }

  private func setupPopover() {
    let contentView = MenuBarContentView()
    self.popover.contentViewController = NSHostingController(rootView: contentView)
    self.popover.contentSize = NSSize(width: 420, height: 580)
    self.popover.behavior = .transient
  }

  private func setupEventMonitor() {
    self.eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseUp, .leftMouseDown]) { [weak self] _ in
      self?.closePopover()
    }
    NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
      if event.modifierFlags.contains(.command), event.charactersIgnoringModifiers == "," {
        self?.closePopover()
        self?.openPreferencesWindow()
        return nil
      }
      return event
    }
  }

  @objc func togglePopover() {
    if self.popover.isShown {
      self.closePopover()
    } else {
      self.openPopover()
    }
  }

  @objc func openPopover() {
    guard let button = statusItem.button else { return }
    self.statusItem.button?.state = .on
    NSApp.activate(ignoringOtherApps: true)
    self.popover.show(relativeTo: .zero, of: button, preferredEdge: .maxY)
    NotificationCenter.default.post(name: .popoverDidOpen, object: nil)
  }

  @objc func closePopover() {
    guard self.popover.isShown else { return }
    self.statusItem.button?.state = .off
    self.popover.close()
  }

  func openPreferencesWindow() {
    if self.preferencesWindow == nil {
      let hostingView = NSHostingView(rootView: PreferencesView())
      hostingView.setFrameSize(hostingView.fittingSize)
      let window = NSWindow(
        contentRect: NSRect(origin: .zero, size: hostingView.fittingSize),
        styleMask: [.titled, .closable],
        backing: .buffered,
        defer: false,
      )
      window.title = gettext("preferences")
      window.contentView = hostingView
      window.center()
      self.preferencesWindow = window
    }
    self.preferencesWindow?.makeKeyAndOrderFront(nil)
    NSApp.activate(ignoringOtherApps: true)
    AnalyticsHelper.shared.trackPreferencesOpened()
  }

  func openAboutWindow() {
    if self.aboutWindow == nil {
      let hostingView = NSHostingView(rootView: AboutView())
      hostingView.setFrameSize(hostingView.fittingSize)
      let window = NSWindow(
        contentRect: NSRect(origin: .zero, size: hostingView.fittingSize),
        styleMask: [.titled, .closable],
        backing: .buffered,
        defer: false,
      )
      window.title = gettext("about")
      window.contentView = hostingView
      window.center()
      self.aboutWindow = window
    }
    self.aboutWindow?.makeKeyAndOrderFront(nil)
    NSApp.activate(ignoringOtherApps: true)
    AnalyticsHelper.shared.trackAboutOpened()
  }
}
