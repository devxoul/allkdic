import Cocoa
import ServiceManagement

enum LoginItem {
  static var status: SMAppService.Status {
    SMAppService.mainApp.status
  }

  static var enabled: Bool {
    status == .enabled
  }

  static var requiresApproval: Bool {
    status == .requiresApproval
  }

  static func setEnabled(_ enabled: Bool) throws {
    if enabled {
      try SMAppService.mainApp.register()
    } else {
      try SMAppService.mainApp.unregister()
    }
  }
}
