//
//  HotKeyAssembly.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 2020/05/06.
//

import Carbon
import Swinject

final class HotKeyAssembly: Assembly {
  func assemble(container: Container) {
    container.register(NotificationCenter.self) { _ in NotificationCenter.default }
    container.register(HotKeyServiceProtocol.self) { r in
      HotKeyService(
        installEventHandler: Carbon.InstallEventHandler,
        registerEventHotKey: Carbon.RegisterEventHotKey,
        unregisterEventHotKey: Carbon.UnregisterEventHotKey,
        notificationCenter: r.resolve()
      )
    }
  }
}
