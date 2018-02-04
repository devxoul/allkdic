//
//  main.swift
//  Allkdic
//
//  Created by Suyeol Jeon on 04/02/2018.
//  Copyright © 2018 Allkdic. All rights reserved.
//

import AppKit

func appDelegate() -> NSApplicationDelegate {
  if let cls = NSClassFromString("AllkdicTests.TestAppDelegate") as? (NSObject & NSApplicationDelegate).Type {
    return cls.init()
  } else {
    return AppDelegate(dependency: AppDependency.resolve())
  }
}

let application = NSApplication.shared
application.delegate = appDelegate()
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
