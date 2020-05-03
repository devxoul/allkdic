//
//  AnalyticsHelperStub.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 2020/05/04.
//

import SimpleCocoaAnalytics
import Testing
@testable import Allkdic

final class AnalyticsHelperStub: AnalyticsHelperProtocol {
  func beginPeriodicReporting(
    withAccount googleAccountIdentifier: String!,
    name appName: String!,
    version appVersion: String!
  ) {
    return Stubber.invoke(beginPeriodicReporting, args: (googleAccountIdentifier, appName, appVersion), default: Void())
  }

  func handleApplicationWillClose() {
    return Stubber.invoke(handleApplicationWillClose, args: (), default: Void())
  }
}
