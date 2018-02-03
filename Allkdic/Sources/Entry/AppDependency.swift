//
//  AppDependency.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 03/02/2018.
//  Copyright © 2018 Allkdic. All rights reserved.
//

import SimpleCocoaAnalytics

struct AppDependency {
  let analyticsHelper: AnalyticsHelperType
}

extension AppDependency {
  static func resolve() -> AppDependency {
    return .init(
      analyticsHelper: AnalyticsHelper.sharedInstance()
    )
  }
}
