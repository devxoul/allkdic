import Cocoa
import WebKit

/// The app has no menu bar (`LSUIElement`), so there is no Close item to route
/// Cmd+W here and no responder handling for Escape. Both are wired up manually.
private final class LoginPopupWindow: NSWindow {
  override func cancelOperation(_: Any?) {
    self.performClose(nil)
  }

  override func performKeyEquivalent(with event: NSEvent) -> Bool {
    guard event.modifierFlags.intersection(.deviceIndependentFlagsMask) == .command,
          event.charactersIgnoringModifiers == "w"
    else {
      return super.performKeyEquivalent(with: event)
    }
    self.performClose(nil)
    return true
  }
}

/// A login window opened by a dictionary page via `window.open`.
///
/// It deliberately does not reuse the dictionary's `Coordinator` as its delegate:
/// those callbacks drive the main view's loading indicator, custom CSS and input
/// focusing, none of which may be triggered by popup navigations.
@MainActor
final class LoginPopupController: NSObject {
  let webView: WKWebView
  var onClose: (() -> Void)?

  private let window: NSWindow
  private var hasFinished = false

  init(configuration: WKWebViewConfiguration, title: String) {
    self.webView = WKWebView(
      frame: NSRect(x: 0, y: 0, width: 480, height: 640),
      configuration: configuration,
    )
    self.window = LoginPopupWindow(
      contentRect: self.webView.frame,
      styleMask: [.titled, .closable, .resizable],
      backing: .buffered,
      defer: false,
    )
    super.init()

    self.webView.uiDelegate = self
    self.webView.navigationDelegate = self

    // Under ARC the controller owns the window; the AppKit-era auto-release
    // would over-release it.
    self.window.isReleasedWhenClosed = false
    self.window.title = title
    self.window.contentView = self.webView
    self.window.delegate = self
    self.window.center()
  }

  func show() {
    // Plain activate(): `ignoringOtherApps` makes Stage Manager treat this as a
    // scene switch and slide other apps' windows aside (see 0746a14).
    NSApp.activate()
    self.window.makeKeyAndOrderFront(nil)
  }

  func close() {
    self.window.close()
  }

  /// Both `webViewDidClose` and `windowWillClose` can fire for a single close.
  private func finish() {
    guard !self.hasFinished else { return }
    self.hasFinished = true

    self.webView.uiDelegate = nil
    self.webView.navigationDelegate = nil
    self.window.delegate = nil

    let onClose = self.onClose
    self.onClose = nil
    onClose?()
  }
}

extension LoginPopupController: WKUIDelegate {
  func webViewDidClose(_: WKWebView) {
    self.close()
  }

  func webView(
    _ webView: WKWebView,
    createWebViewWith _: WKWebViewConfiguration,
    for navigationAction: WKNavigationAction,
    windowFeatures _: WKWindowFeatures,
  ) -> WKWebView? {
    // Keep secondary flows ("find ID/password") in this window rather than
    // stacking more windows on top.
    guard navigationAction.targetFrame == nil else { return nil }
    webView.load(navigationAction.request)
    return nil
  }
}

extension LoginPopupController: WKNavigationDelegate {
  func webView(
    _: WKWebView,
    decidePolicyFor navigationAction: WKNavigationAction,
    decisionHandler: @escaping (WKNavigationActionPolicy) -> Void,
  ) {
    guard let url = navigationAction.request.url, let scheme = url.scheme?.lowercased() else {
      decisionHandler(.cancel)
      return
    }

    switch scheme {
    case "http", "https", "about", "data", "blob":
      decisionHandler(.allow)

    // "Log in with the app" hands off to a native app WebKit cannot load. Only
    // known schemes are forwarded, so a page cannot launch arbitrary apps.
    case "naversearchapp", "kakaotalk":
      decisionHandler(.cancel)
      NSWorkspace.shared.open(url)

    default:
      decisionHandler(.cancel)
    }
  }
}

extension LoginPopupController: NSWindowDelegate {
  func windowWillClose(_: Notification) {
    self.finish()
  }
}
