//
//  StubAnalyticsHelper.swift
//  AllkdicTests
//
//  Created by Suyeol Jeon on 04/02/2018.
//  Copyright © 2018 Allkdic. All rights reserved.
//

import SimpleCocoaAnalytics
import Stubber
@testable import Allkdic

final class StubAnalyticsHelper: AnalyticsHelperType {
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

  func recordCachedEvent(withCategory eventCategory: String!, action eventAction: String!, label eventLabel: String!, value eventValue: NSNumber!) {
    return Stubber.invoke(recordCachedEvent, args: (eventCategory, eventAction, eventLabel, eventValue), default: Void())
  }
}
