//
//  AnalyticsAssembly.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 2020/05/04.
//

import SimpleCocoaAnalytics
import Swinject

final class AnalyticsAssembly: Assembly {
  func assemble(container: Container) {
    container.register(AnalyticsHelperProtocol.self) { _ in AnalyticsHelper.sharedInstance() }
  }
}
