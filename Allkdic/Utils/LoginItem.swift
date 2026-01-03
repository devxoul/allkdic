// The MIT License (MIT)
//
// Copyright (c) 2015 Suyeol Jeon (http://xoul.kr)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Cocoa
import ServiceManagement

final class LoginItem {

  private static let launcherIdentifier = "kr.xoul.allkdic.LauncherApplication"

  static var enabled: Bool {
    let service = SMAppService.loginItem(identifier: launcherIdentifier)
    return service.status == .enabled
  }

  static func setEnabled(_ enabled: Bool) {
    let service = SMAppService.loginItem(identifier: launcherIdentifier)
    do {
      if enabled {
        try service.register()
      } else {
        try service.unregister()
      }
    } catch {
      NSLog("LoginItem setEnabled(\(enabled)) failed: \(error)")
    }
  }
}
