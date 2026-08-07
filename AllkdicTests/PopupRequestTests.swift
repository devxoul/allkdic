@testable import Allkdic
import WebKit
import XCTest

final class PopupRequestTests: XCTestCase {
  private func makeRequest(
    url: String?,
    sourceURL: String? = "https://en.dict.naver.com/#/mini/main",
    navigationType: WKNavigationType = .other,
  ) -> PopupRequest {
    PopupRequest(
      url: url.flatMap { URL(string: $0) },
      sourceURL: sourceURL.flatMap { URL(string: $0) },
      navigationType: navigationType,
    )
  }

  // MARK: - Login popups open in the app

  func test_disposition_naverLoginHost() {
    let request = self.makeRequest(url: "https://nid.naver.com/nidlogin.login")
    XCTAssertEqual(request.disposition, .inAppLogin)
  }

  func test_disposition_daumLoginHost() {
    let request = self.makeRequest(
      url: "https://logins.daum.net/accounts/loginform.do",
      sourceURL: "https://small.dic.daum.net/top/search.do",
    )
    XCTAssertEqual(request.disposition, .inAppLogin)
  }

  func test_disposition_kakaoAccountsHost() {
    let request = self.makeRequest(
      url: "https://accounts.kakao.com/login",
      sourceURL: "https://small.dic.daum.net/top/search.do",
    )
    XCTAssertEqual(request.disposition, .inAppLogin)
  }

  // A login link may arrive as a plain link activation rather than script.
  func test_disposition_loginHost_viaLinkActivated() {
    let request = self.makeRequest(url: "https://nid.naver.com/nidlogin.login", navigationType: .linkActivated)
    XCTAssertEqual(request.disposition, .inAppLogin)
  }

  // MARK: - Content links stay in the browser (#66)

  func test_disposition_contentLink_viaLinkActivated() {
    let request = self.makeRequest(
      url: "https://dict.naver.com/frdict/#/entry/frko/conjugation",
      navigationType: .linkActivated,
    )
    XCTAssertEqual(request.disposition, .externalBrowser)
  }

  // The same link once the page intercepts the click with JavaScript.
  func test_disposition_contentLink_viaScript() {
    let request = self.makeRequest(url: "https://dict.naver.com/frdict/#/entry/frko/conjugation")
    XCTAssertEqual(request.disposition, .externalBrowser)
  }

  func test_disposition_unrelatedHostOnSameDomain() {
    let request = self.makeRequest(url: "https://ad.naver.com/promotion")
    XCTAssertEqual(request.disposition, .externalBrowser)
  }

  // A lookalike host must never inherit the login window's cookie store.
  func test_disposition_lookalikeLoginHost() {
    let request = self.makeRequest(url: "https://nid.naver.com.example.com/nidlogin.login")
    XCTAssertEqual(request.disposition, .externalBrowser)
  }

  // A trusted host must not drag an unsupported scheme into the login window.
  func test_disposition_loginHostWithFileScheme() {
    let request = self.makeRequest(url: "file://nid.naver.com/nidlogin.login")
    XCTAssertEqual(request.disposition, .deny)
  }

  func test_disposition_loginHostWithCustomScheme() {
    let request = self.makeRequest(url: "naversearchapp://nid.naver.com/nidlogin.login")
    XCTAssertEqual(request.disposition, .deny)
  }

  // MARK: - Blank popups navigated after opening

  func test_disposition_blankPopupFromDictionary() {
    let request = self.makeRequest(url: "about:blank")
    XCTAssertEqual(request.disposition, .inAppLogin)
  }

  func test_disposition_missingURLFromDictionary() {
    let request = self.makeRequest(url: nil)
    XCTAssertEqual(request.disposition, .inAppLogin)
  }

  func test_disposition_blankPopupFromSubdomainOfDictionary() {
    let request = self.makeRequest(url: "about:blank", sourceURL: "https://small.dic.daum.net/top/search.do")
    XCTAssertEqual(request.disposition, .inAppLogin)
  }

  func test_disposition_blankPopupFromUntrustedSource() {
    let request = self.makeRequest(url: "about:blank", sourceURL: "https://example.com")
    XCTAssertEqual(request.disposition, .deny)
  }

  func test_disposition_blankPopupFromLookalikeSource() {
    let request = self.makeRequest(url: "about:blank", sourceURL: "https://dict.naver.com.example.com")
    XCTAssertEqual(request.disposition, .deny)
  }

  func test_disposition_blankPopup_viaLinkActivated() {
    let request = self.makeRequest(url: nil, navigationType: .linkActivated)
    XCTAssertEqual(request.disposition, .deny)
  }

  // Only a genuinely blank URL is a bootstrap; other about: URLs are not.
  func test_disposition_nonBlankAboutURL() {
    let request = self.makeRequest(url: "about:srcdoc")
    XCTAssertEqual(request.disposition, .deny)
  }

  // MARK: - Everything else is denied

  func test_disposition_customScheme() {
    let request = self.makeRequest(url: "naversearchapp://search?query=test")
    XCTAssertEqual(request.disposition, .deny)
  }

  func test_disposition_fileScheme() {
    let request = self.makeRequest(url: "file:///etc/passwd")
    XCTAssertEqual(request.disposition, .deny)
  }

  func test_disposition_javascriptScheme() {
    let request = self.makeRequest(url: "javascript:alert(1)")
    XCTAssertEqual(request.disposition, .deny)
  }
}
