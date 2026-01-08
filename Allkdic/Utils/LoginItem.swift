import Cocoa
import ServiceManagement

enum LoginItem {
  static var enabled: Bool {
    SMAppService.mainApp.status == .enabled
  }

  static func setEnabled(_ enabled: Bool) {
    do {
      if enabled {
        try SMAppService.mainApp.register()
      } else {
        try SMAppService.mainApp.unregister()
      }
    } catch {
      NSLog("LoginItem setEnabled(\(enabled)) failed: \(error)")
    }
  }
}
