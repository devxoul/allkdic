import SwiftUI
import WebKit

struct DictionaryWebView: View {
  let dictionary: DictionaryType
  @State private var isLoading = true

  var body: some View {
    ZStack {
      WebView(dictionary: dictionary, isLoading: $isLoading)

      if isLoading {
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
    context.coordinator.webView = webView
    loadIfNeeded(webView, context: context)
    return webView
  }

  func updateNSView(_ webView: WKWebView, context: Context) {
    context.coordinator.dictionary = dictionary
    loadIfNeeded(webView, context: context)
  }

  private func loadIfNeeded(_ webView: WKWebView, context: Context) {
    guard context.coordinator.lastLoadedURL != dictionary.URLString else { return }
    guard let url = URL(string: dictionary.URLString) else { return }

    context.coordinator.lastLoadedURL = dictionary.URLString
    let request = URLRequest(url: url)
    webView.load(request)
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(isLoading: $isLoading, dictionary: dictionary)
  }

  @MainActor
  class Coordinator: NSObject, WKNavigationDelegate {
    @Binding var isLoading: Bool
    var dictionary: DictionaryType
    var lastLoadedURL: String?
    weak var webView: WKWebView?
    private nonisolated(unsafe) var popoverObserver: NSObjectProtocol?

    init(isLoading: Binding<Bool>, dictionary: DictionaryType) {
      self._isLoading = isLoading
      self.dictionary = dictionary
      super.init()
      setupPopoverObserver()
    }

    deinit {
      if let observer = popoverObserver {
        NotificationCenter.default.removeObserver(observer)
      }
    }

    private func setupPopoverObserver() {
      popoverObserver = NotificationCenter.default.addObserver(
        forName: .popoverDidOpen,
        object: nil,
        queue: .main
      ) { [weak self] _ in
        Task { @MainActor in
          self?.focusInput()
        }
      }
    }

    private func focusInput() {
      webView?.evaluateJavaScript(dictionary.inputFocusingScript)
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
      isLoading = true
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      isLoading = false
      if let css = dictionary.customCSS {
        let script = """
          var style = document.createElement('style');
          style.textContent = `\(css)`;
          document.head.appendChild(style);
          """
        webView.evaluateJavaScript(script)
      }
      focusInput()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
      isLoading = false
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
      isLoading = false
    }
  }
}

#Preview {
  DictionaryWebView(dictionary: .Naver)
    .frame(width: 420, height: 500)
}
