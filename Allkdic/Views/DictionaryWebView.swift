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
  class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, NSWindowDelegate {
    @Binding var isLoading: Bool
    var dictionary: DictionaryType
    var lastLoadedURL: String?
    weak var webView: WKWebView?
    private nonisolated(unsafe) var popoverObserver: NSObjectProtocol?
    private var popupWindow: NSWindow?

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
      guard self.lastLoadedURL == nil, let url = URL(string: self.dictionary.URLString) else { return }
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

    // Naver/Daum 로그인은 팝업 창(window.open)으로 뜨는데, 이걸 외부 브라우저로 보내면
    // 로그인 세션 쿠키가 앱의 WKWebView 데이터스토어와 공유되지 않아 로그인이 반영되지 않는다.
    // 전달받은 configuration을 그대로 재사용해 같은 데이터스토어를 쓰는 팝업 웹뷰를 앱 안에 띄운다.
    func webView(
      _: WKWebView,
      createWebViewWith configuration: WKWebViewConfiguration,
      for _: WKNavigationAction,
      windowFeatures _: WKWindowFeatures,
    ) -> WKWebView? {
      self.popupWindow?.close()

      let popupWebView = WKWebView(frame: NSRect(x: 0, y: 0, width: 480, height: 640), configuration: configuration)
      popupWebView.navigationDelegate = self
      popupWebView.uiDelegate = self

      let window = NSWindow(
        contentRect: popupWebView.frame,
        styleMask: [.titled, .closable, .resizable],
        backing: .buffered,
        defer: false,
      )
      window.isReleasedWhenClosed = false
      window.title = self.dictionary.title
      window.contentView = popupWebView
      window.delegate = self
      window.center()
      window.makeKeyAndOrderFront(nil)
      NSApp.activate(ignoringOtherApps: true)

      self.popupWindow = window
      return popupWebView
    }

    // 로그인 완료 후 팝업이 스스로 닫힐 때(window.close()) 호출된다.
    func webViewDidClose(_: WKWebView) {
      self.popupWindow?.close()
    }

    // 팝업이 어떤 경로로든(로그인 완료, 사용자가 직접 닫기) 닫히면
    // 로그인 세션이 반영되도록 메인 웹뷰를 새로고침한다.
    func windowWillClose(_ notification: Notification) {
      guard notification.object as? NSWindow === self.popupWindow else { return }
      self.popupWindow = nil
      self.webView?.reload()
    }
  }
}

#Preview {
  DictionaryWebView(dictionary: .Naver)
    .frame(width: 420, height: 500)
}
