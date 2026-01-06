import Cocoa
import SwiftUI

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
  @objc static private(set) var shared: AppDelegate!

  private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
  private let popover = NSPopover()
  private var eventMonitor: Any?
  private var preferencesWindow: NSWindow?
  private var aboutWindow: NSWindow?

  override init() {
    super.init()
    UserDefaults.standard.set(false, forKey: "NSQuitAlwaysKeepsWindows")
  }

  func applicationDidFinishLaunching(_ notification: Notification) {
    AppDelegate.shared = self
    setupStatusItem()
    setupPopover()
    setupEventMonitor()
    HotKeyManager.registerHotKey()
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
    NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
      if event.modifierFlags.contains(.command) && event.charactersIgnoringModifiers == "," {
        self?.closePopover()
        self?.openPreferencesWindow()
        return nil
      }
      return event
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
    NotificationCenter.default.post(name: .popoverDidOpen, object: nil)
    AnalyticsHelper.shared.trackAppOpened()
  }

  @objc func closePopover() {
    guard popover.isShown else { return }
    statusItem.button?.state = .off
    popover.close()
    AnalyticsHelper.shared.trackAppClosed()
  }

  func openPreferencesWindow() {
    if preferencesWindow == nil {
      let hostingView = NSHostingView(rootView: PreferencesView())
      hostingView.setFrameSize(hostingView.fittingSize)
      let window = NSWindow(
        contentRect: NSRect(origin: .zero, size: hostingView.fittingSize),
        styleMask: [.titled, .closable],
        backing: .buffered,
        defer: false
      )
      window.title = gettext("preferences")
      window.contentView = hostingView
      window.center()
      preferencesWindow = window
    }
    preferencesWindow?.makeKeyAndOrderFront(nil)
    NSApp.activate(ignoringOtherApps: true)
    AnalyticsHelper.shared.trackPreferencesOpened()
  }

  func openAboutWindow() {
    if aboutWindow == nil {
      let hostingView = NSHostingView(rootView: AboutView())
      hostingView.setFrameSize(hostingView.fittingSize)
      let window = NSWindow(
        contentRect: NSRect(origin: .zero, size: hostingView.fittingSize),
        styleMask: [.titled, .closable],
        backing: .buffered,
        defer: false
      )
      window.title = gettext("about")
      window.contentView = hostingView
      window.center()
      aboutWindow = window
    }
    aboutWindow?.makeKeyAndOrderFront(nil)
    NSApp.activate(ignoringOtherApps: true)
    AnalyticsHelper.shared.trackAboutOpened()
  }
}
