//
//  AppDependency.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 2020/05/04.
//

import Swinject
import SwinjectAutoregistration

struct AppDependency {
}

extension AppDependency {
  static func resolve() -> AppDependency {
    let assemblies: [Assembly] = [
      AnalyticsAssembly(),
    ]
    let container = Container()
    let assembler = Assembler(assemblies, container: container)
    let resolver = assembler.resolver

    container.autoregister(AppDependency.self, initializer: AppDependency.init)
    return resolver.resolve()
  }
}
