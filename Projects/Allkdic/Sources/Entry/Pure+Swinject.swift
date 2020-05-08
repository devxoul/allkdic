//
//  Pure+Swinject.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 2020/05/09.
//

import Pure
import Swinject
import SwinjectAutoregistration

extension Container {
  func register<Module, Arg1>(_ factory: Factory<Module>.Type, dependency: @escaping (Arg1) -> Module.Dependency) where Module: FactoryModule {
    if Arg1.self == Void.self {
      self.register(Void.self) { _ in Void() }
    }
    self.autoregister(Module.Dependency.self, initializer: dependency)
    self.autoregister(factory)
  }

  func register<Module, Arg1, Arg2>(_ factory: Factory<Module>.Type, dependency: @escaping ((Arg1, Arg2)) -> Module.Dependency) where Module: FactoryModule {
    self.autoregister(Module.Dependency.self, initializer: dependency)
    self.autoregister(factory)
  }

  func register<Module, Arg1, Arg2, Arg3>(_ factory: Factory<Module>.Type, dependency: @escaping ((Arg1, Arg2, Arg3)) -> Module.Dependency) where Module: FactoryModule {
    self.autoregister(Module.Dependency.self, initializer: dependency)
    self.autoregister(factory)
  }

  func register<Module, Arg1, Arg2, Arg3, Arg4>(_ factory: Factory<Module>.Type, dependency: @escaping ((Arg1, Arg2, Arg3, Arg4)) -> Module.Dependency) where Module: FactoryModule {
    self.autoregister(Module.Dependency.self, initializer: dependency)
    self.autoregister(factory)
  }

  func register<Module, Arg1, Arg2, Arg3, Arg4, Arg5>(_ factory: Factory<Module>.Type, dependency: @escaping ((Arg1, Arg2, Arg3, Arg4, Arg5)) -> Module.Dependency) where Module: FactoryModule {
    self.autoregister(Module.Dependency.self, initializer: dependency)
    self.autoregister(factory)
  }

  func register<Module, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6>(_ factory: Factory<Module>.Type, dependency: @escaping ((Arg1, Arg2, Arg3, Arg4, Arg5, Arg6)) -> Module.Dependency) where Module: FactoryModule {
    self.autoregister(Module.Dependency.self, initializer: dependency)
    self.autoregister(factory)
  }

  func register<Module, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7>(_ factory: Factory<Module>.Type, dependency: @escaping ((Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7)) -> Module.Dependency) where Module: FactoryModule {
    self.autoregister(Module.Dependency.self, initializer: dependency)
    self.autoregister(factory)
  }

  func register<Module, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8>(_ factory: Factory<Module>.Type, dependency: @escaping ((Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8)) -> Module.Dependency) where Module: FactoryModule {
    self.autoregister(Module.Dependency.self, initializer: dependency)
    self.autoregister(factory)
  }

  func register<Module, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9>(_ factory: Factory<Module>.Type, dependency: @escaping ((Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9)) -> Module.Dependency) where Module: FactoryModule {
    self.autoregister(Module.Dependency.self, initializer: dependency)
    self.autoregister(factory)
  }

  func register<Module, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10>(_ factory: Factory<Module>.Type, dependency: @escaping ((Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9, Arg10)) -> Module.Dependency) where Module: FactoryModule {
    self.autoregister(Module.Dependency.self, initializer: dependency)
    self.autoregister(factory)
  }

  private func autoregister<Module>(_ factory: Factory<Module>.Type) where Module: FactoryModule {
    self.register((() -> Module.Dependency).self) { r in
      // If the dependency is resolved lazily, the container cannot verify missing dependencies.
      // But it can cause overhead so we need to find a better solution in the future.
      let dependency = r.resolve(Module.Dependency.self)!
      return { dependency }
    }
    self.autoregister(Factory<Module>.self, initializer: Factory<Module>.init)
  }
}
