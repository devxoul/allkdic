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

private struct WebView: NSViewRepresentable {
  let dictionary: DictionaryType
  @Binding var isLoading: Bool

  func makeNSView(context: Context) -> WKWebView {
    let webView = WKWebView()
    webView.navigationDelegate = context.coordinator
    loadIfNeeded(webView, context: context)
    return webView
  }

  func updateNSView(_ webView: WKWebView, context: Context) {
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

  class Coordinator: NSObject, WKNavigationDelegate {
    @Binding var isLoading: Bool
    var dictionary: DictionaryType
    var lastLoadedURL: String?

    init(isLoading: Binding<Bool>, dictionary: DictionaryType) {
      self._isLoading = isLoading
      self.dictionary = dictionary
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
      isLoading = true
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      isLoading = false
      webView.evaluateJavaScript(dictionary.inputFocusingScript)
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
