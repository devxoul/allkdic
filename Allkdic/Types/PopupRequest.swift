import WebKit

enum PopupDisposition: Equatable {
  /// Opened inside the app so the session lands in the same cookie store as the
  /// dictionary web view.
  case inAppLogin
  /// Handed to the default browser: full-site pages are unusable at popover size.
  case externalBrowser
  case deny
}

/// The parts of a `WKNavigationAction` that popup routing depends on.
///
/// Modelled as plain values because `WKNavigationAction` and `WKWindowFeatures`
/// are framework-produced and cannot be constructed in tests.
struct PopupRequest: Equatable {
  let url: URL?
  let sourceURL: URL?
  let navigationType: WKNavigationType

  /// Exact hosts, never suffix matches: `*.naver.com` or `*.daum.net` would
  /// gradually promote unrelated content and ad popups into in-app windows that
  /// share the logged-in cookie store.
  private static let authenticationHosts: Set<String> = [
    "nid.naver.com",
    "logins.daum.net",
    "accounts.kakao.com",
  ]

  private static let dictionaryHosts: Set<String> = [
    "dict.naver.com",
    "dic.daum.net",
  ]

  var disposition: PopupDisposition {
    if self.isBlankBootstrap {
      let opensLoginWindow = self.navigationType == .other && self.isFromDictionary
      return opensLoginWindow ? .inAppLogin : .deny
    }

    // The scheme is checked before the host so that a host we trust cannot pull
    // an unsupported scheme, such as file://nid.naver.com/, into a window that
    // shares logged-in cookies.
    guard let url = self.url, let scheme = url.scheme?.lowercased(), scheme == "http" || scheme == "https" else {
      return .deny
    }

    if let host = url.host?.lowercased(), Self.authenticationHosts.contains(host) {
      return .inAppLogin
    }

    return .externalBrowser
  }

  /// `window.open("", name, features)` opens an empty window and navigates it
  /// afterwards, so the login URL isn't known yet when the window is requested.
  /// Only a genuinely blank URL qualifies; other `about:` URLs are not.
  private var isBlankBootstrap: Bool {
    guard let url = self.url else { return true }
    return url.absoluteString.lowercased() == "about:blank"
  }

  private var isFromDictionary: Bool {
    guard let host = self.sourceURL?.host?.lowercased() else { return false }
    return Self.dictionaryHosts.contains(host) || Self.dictionaryHosts.contains { host.hasSuffix(".\($0)") }
  }
}
