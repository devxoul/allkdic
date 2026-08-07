import SwiftUI
import WebKit

struct DictionaryWebView: View {
  let dictionary: DictionaryType
  @State private var isLoading = true

  var body: some View {
    ZStack {
      WebView(dictionary: self.dictionary, isLoading: self.$isLoading)

      if self.isLoading {
        ProgressView()
          .progressViewStyle(.circular)
          .controlSize(.regular)
      }
    }
  }
}

private final class NoBeepWebView: WKWebView {
  override func performKeyEquivalent(with event: NSEvent) -> Bool {
    if event.keyCode == 36 || event.keyCode == 76 { return true }
    return super.performKeyEquivalent(with: event)
  }
}

private struct WebView: NSViewRepresentable {
  let dictionary: DictionaryType
  @Binding var isLoading: Bool

  func makeNSView(context: Context) -> WKWebView {
    let webView = NoBeepWebView()
    webView.navigationDelegate = context.coordinator
    webView.uiDelegate = context.coordinator
    context.coordinator.webView = webView
    self.loadIfNeeded(webView, context: context)
    return webView
  }

  func updateNSView(_ webView: WKWebView, context: Context) {
    context.coordinator.dictionary = self.dictionary
    self.loadIfNeeded(webView, context: context)
  }

  private func loadIfNeeded(_ webView: WKWebView, context: Context) {
    guard context.coordinator.lastLoadedURL != self.dictionary.URLString else { return }
    guard let url = URL(string: dictionary.URLString) else { return }

    context.coordinator.lastLoadedURL = self.dictionary.URLString
    let request = URLRequest(url: url)
    webView.load(request)
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(isLoading: self.$isLoading, dictionary: self.dictionary)
  }

  @MainActor
  class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
    @Binding var isLoading: Bool
    var dictionary: DictionaryType
    var lastLoadedURL: String?
    weak var webView: WKWebView?
    private nonisolated(unsafe) var popoverObserver: NSObjectProtocol?
    private var loginPopupController: LoginPopupController?
    private var needsSessionReload = false

    init(isLoading: Binding<Bool>, dictionary: DictionaryType) {
      _isLoading = isLoading
      self.dictionary = dictionary
      super.init()
      self.setupPopoverObserver()
    }

    deinit {
      if let observer = popoverObserver {
        NotificationCenter.default.removeObserver(observer)
      }
    }

    private func setupPopoverObserver() {
      self.popoverObserver = NotificationCenter.default.addObserver(
        forName: .popoverDidOpen,
        object: nil,
        queue: .main,
      ) { [weak self] _ in
        Task { @MainActor in
          self?.reloadIfNeeded()
          self?.focusInput()
        }
      }
    }

    private func reloadIfNeeded() {
      guard self.lastLoadedURL != nil else {
        self.loadDictionary()
        return
      }
      guard self.needsSessionReload else { return }
      self.isLoading = true
      self.webView?.reload()
    }

    private func loadDictionary() {
      guard let url = URL(string: self.dictionary.URLString) else { return }
      self.lastLoadedURL = self.dictionary.URLString
      self.isLoading = true
      self.webView?.load(URLRequest(url: url))
    }

    private func focusInput() {
      guard let webView = self.webView else { return }
      webView.window?.makeFirstResponder(webView)
      webView.evaluateJavaScript(self.dictionary.inputFocusingScript)
    }

    func webView(_: WKWebView, didStartProvisionalNavigation _: WKNavigation!) {
      self.isLoading = true
    }

    func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
      self.isLoading = false
      // Cleared only once a load actually lands, so a reload that fails while
      // offline is retried on the next popover open instead of being lost.
      self.needsSessionReload = false
      if let css = dictionary.customCSS {
        let script = """
        var style = document.createElement('style');
        style.textContent = `\(css)`;
        document.head.appendChild(style);
        """
        webView.evaluateJavaScript(script)
      }
      self.focusInput()
    }

    func webView(_: WKWebView, didFail _: WKNavigation!, withError _: Error) {
      self.isLoading = false
    }

    func webView(_: WKWebView, didFailProvisionalNavigation _: WKNavigation!, withError _: Error) {
      self.isLoading = false
    }

    func webViewWebContentProcessDidTerminate(_: WKWebView) {
      self.lastLoadedURL = nil
    }

    func webView(
      _: WKWebView,
      createWebViewWith configuration: WKWebViewConfiguration,
      for navigationAction: WKNavigationAction,
      windowFeatures _: WKWindowFeatures,
    ) -> WKWebView? {
      let request = PopupRequest(
        url: navigationAction.request.url,
        sourceURL: navigationAction.sourceFrame.request.url,
        navigationType: navigationAction.navigationType,
      )

      switch request.disposition {
      case .inAppLogin:
        return self.presentLoginPopup(configuration: configuration)

      case .externalBrowser:
        if let url = request.url {
          NSWorkspace.shared.open(url)
        }
        return nil

      case .deny:
        return nil
      }
    }

    /// Reuses the configuration WebKit passes in, which is what ties the popup
    /// to the dictionary web view's cookie store and makes the login stick.
    private func presentLoginPopup(configuration: WKWebViewConfiguration) -> WKWebView? {
      self.loginPopupController?.close()

      let controller = LoginPopupController(configuration: configuration, title: self.dictionary.title)
      controller.onClose = { [weak self] in
        self?.loginPopupController = nil
        self?.needsSessionReload = true
      }
      controller.show()
      self.loginPopupController = controller

      return controller.webView
    }
  }
}

#Preview {
  DictionaryWebView(dictionary: .Naver)
    .frame(width: 420, height: 500)
}
