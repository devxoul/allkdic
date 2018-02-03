//
//  main.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 04/02/2018.
//  Copyright © 2018 Allkdic. All rights reserved.
//

import AppKit

autoreleasepool {
  let application = NSApplication.shared
  let delegate = AppDelegate(dependency: AppDependency.resolve())
  application.delegate = delegate
  application.run()
}
