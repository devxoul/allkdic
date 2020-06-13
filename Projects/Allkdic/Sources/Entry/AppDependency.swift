//
//  AppDependency.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 2020/05/04.
//

import Swinject
import SwinjectAutoregistration

struct AppDependency {
  let analyticsHelper: AnalyticsHelperProtocol
  let preferenceService: PreferenceServiceProtocol
  let hotKeyService: HotKeyServiceProtocol
  let statusItemControllerFactory: StatusItemController.Factory
  let popoverControllerFactory: PopoverController.Factory
}

extension AppDependency {
  static func resolve() -> AppDependency {
    let assemblies: [Assembly] = [
      AnalyticsAssembly(),
      PreferenceAssembly(),
      HotKeyAssembly(),
      StatusItemAssembly(),
      PopoverAssembly(),
    ]
    let container = Container(defaultObjectScope: .graph)
    let assembler = Assembler(assemblies, container: container)
    let resolver = assembler.resolver

    container.autoregister(AppDependency.self, initializer: AppDependency.init)
    return resolver.resolve()
  }
}
