//
//  AnalyticsHelperProtocol.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 2020/05/04.
//

import SimpleCocoaAnalytics

protocol AnalyticsHelperProtocol {
  func beginPeriodicReporting(
    withAccount googleAccountIdentifier: String!,
    name appName: String!,
    version appVersion: String!
  )
  func handleApplicationWillClose()

  func recordScreen(withName screenName: String!)
  func recordCachedEvent(withCategory eventCategory: String!, action eventAction: String!, label eventLabel: String!, value eventValue: NSNumber!)
}

extension AnalyticsHelper: AnalyticsHelperProtocol {
}
