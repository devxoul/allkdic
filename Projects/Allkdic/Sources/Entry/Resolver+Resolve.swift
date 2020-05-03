//
//  Resolver+Resolve.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 2020/05/04.
//

import Swinject

extension Resolver {
  func resolve<Service>() -> Service! {
    return self.resolve(Service.self)
  }
}
