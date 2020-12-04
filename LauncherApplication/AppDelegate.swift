//
//  AppDelegate.swift
//  LauncherApplication
//
//  Created by Jeong on 2017. 1. 27..
//  Copyright © 2017년 Allkdic. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    let mainAppIdentifier = "kr.xoul.allkdic"
    
    let runningApps = NSWorkspace.shared.runningApplications
    let alreadyRunning = runningApps.filter { $0.bundleIdentifier == mainAppIdentifier }.count > 0
    
    if !alreadyRunning {
      let path = Bundle.main.bundlePath as NSString
      var components = path.pathComponents
      components.removeLast()
      components.removeLast()
      components.removeLast()
      components.append("MacOS")
      components.append("Allkdic")
      
      let newPath = NSString.path(withComponents: components)
      
      NSWorkspace.shared.launchApplication(newPath)
    }
    self.terminate()
  }
  
  func terminate() {
    NSApp.terminate(nil)
  }

}

