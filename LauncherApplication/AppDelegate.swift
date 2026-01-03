import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

  func applicationDidFinishLaunching(_ notification: Notification) {
    let mainAppIdentifier = "kr.xoul.allkdic"

    let runningApps = NSWorkspace.shared.runningApplications
    let alreadyRunning = runningApps.contains { $0.bundleIdentifier == mainAppIdentifier }

    if !alreadyRunning {
      let path = Bundle.main.bundlePath as NSString
      var components = path.pathComponents
      components.removeLast(3)
      components.append("MacOS")
      components.append("Allkdic")

      let newPath = NSString.path(withComponents: components)

      if let url = URL(string: "file://\(newPath)") {
        let configuration = NSWorkspace.OpenConfiguration()
        NSWorkspace.shared.openApplication(at: url, configuration: configuration) { _, _ in }
      }
    }
    self.terminate()
  }

  func terminate() {
    NSApp.terminate(nil)
  }
}
