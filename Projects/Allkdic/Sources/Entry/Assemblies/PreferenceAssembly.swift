//
//  PreferenceAssembly.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 2020/05/06.
//

import Swinject

final class PreferenceAssembly: Assembly {
  func assemble(container: Container) {
    container.register(UserDefaultsProtocol.self) { _ in UserDefaults.standard }
    container.autoregister(PreferenceServiceProtocol.self, initializer: PreferenceService.init)
  }
}
