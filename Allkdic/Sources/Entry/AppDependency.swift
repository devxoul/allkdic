//
//  AppDependency.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 03/02/2018.
//  Copyright © 2018 Allkdic. All rights reserved.
//

import Carbon
import SimpleCocoaAnalytics

struct AppDependency {
  let analyticsHelper: AnalyticsHelperType
  let hotKeyService: HotKeyServiceType
}

extension AppDependency {
  static func resolve() -> AppDependency {
    let userDefaultsService = UserDefaultsService(defaults: UserDefaults.standard)
    return .init(
      analyticsHelper: AnalyticsHelper.sharedInstance(),
      hotKeyService: HotKeyService(
        installEventHandler: Carbon.InstallEventHandler,
        registerEventHotKey: Carbon.RegisterEventHotKey,
        unregisterEventHotKey: Carbon.UnregisterEventHotKey,
        userDefaultsService: userDefaultsService,
        popoverController: PopoverController.sharedInstance()
      )
    )
  }
}
