/*
 The MIT License (MIT)

 Copyright (c) 2013-2014 Suyeol Jeon (http://xoul.kr)

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
*/

import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(notification: NSNotification) {
        self.terminateAlreadyRunning()

        self.moveToApplicationFolderIfNeeded()

        AKHotKeyManager.registerHotKey()

        if !LoginUtil.willStartAtLogin() {
            LoginUtil.setStartAtLoginEnabled(true)
        }

        let ga = AnalyticsHelper.sharedInstance()
        ga.beginPeriodicReportingWithAccount("UA-42976442-2", name:"올ㅋ사전", version: BundleInfo.Version)

        SUUpdater.sharedUpdater().checkForUpdatesInBackground()
    }

    func applicationWillTerminate(notification: NSNotification) {
        AnalyticsHelper.sharedInstance().handleApplicationWillClose()
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    func terminateAlreadyRunning() {
        let pid = NSProcessInfo.processInfo().processIdentifier
        let cmd = "ps aux | grep 'Contents/MacOS/Allkdic' | awk '{ if($2 != \(pid)) print $2 }' | xargs kill -9"
        let task = NSTask.launchedTaskWithLaunchPath("/bin/sh", arguments: ["-c", cmd])
        task.waitUntilExit()
    }

    func moveToApplicationFolderIfNeeded() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let ignore = userDefaults.boolForKey(UserDefaultsKey.IgnoreApplicationFolderWarning)
        if ignore {
            return
        }

        if self.isInApplicationFolder() {
            return
        }

        let alert = NSAlert()
        alert.messageText = "올ㅋ사전이 애플리케이션 폴더에 있지 않습니다."
        alert.informativeText = "자동 업데이트 등의 기능이 원활하게 이루어지지 않을 수 있습니다.\n지금 이동하시겠습니까?"
        alert.addButtonWithTitle("이동")
        alert.addButtonWithTitle("취소")
        alert.addButtonWithTitle("다시 묻지 않음")

        let response = alert.runModal()

        // 다시 묻지 않음
        if response == 1002 {
            userDefaults.setObject(true, forKey: UserDefaultsKey.IgnoreApplicationFolderWarning)
            userDefaults.synchronize()
        }

        // 이동
        else if response == 1000 {
            self.moveToApplicationFolder()
        }
    }

    func isInApplicationFolder() -> Bool {
        let bundlePath = NSBundle.mainBundle().bundlePath
        let paths = NSSearchPathForDirectoriesInDomains(.ApplicationDirectory, .AllDomainsMask, true) as [String]
        for path in paths {
            if bundlePath.hasPrefix(path) {
                return true
            }
        }
        return false
    }

    func moveToApplicationFolder() {
        let sourcePath = NSBundle.mainBundle().bundlePath
        let bundleName = sourcePath.lastPathComponent
        let applicationPaths = NSSearchPathForDirectoriesInDomains(.ApplicationDirectory, .LocalDomainMask, true)
        let destPath = (applicationPaths.last as NSString).stringByAppendingPathComponent(bundleName)

        let fileManager = NSFileManager.defaultManager()
        let existing = fileManager.fileExistsAtPath(destPath)
        if existing {
            // Terminate running process at destination path.
            let cmd = "ps aux | grep '\(destPath)' | awk '{print $2}' | xargs kill -9"
            let task = NSTask.launchedTaskWithLaunchPath("/bin/sh", arguments: ["-c", cmd])
            task.waitUntilExit()

            // Move existing app to trash
            let success = NSWorkspace.sharedWorkspace().performFileOperation(
                NSWorkspaceRecycleOperation,
                source: destPath.stringByDeletingLastPathComponent,
                destination: "",
                files: [bundleName],
                tag: nil
            )

            if !success {
                NSLog("Failed to trash existing app.")
            }
        }

        // Copy to `/Application` folder.
        var error: NSError?
        fileManager.copyItemAtPath(sourcePath, toPath: destPath, error: &error)
        if error? != nil {
            NSLog("Error copying file: \(error)")
        }

        // Remove downloaded app to trash
        fileManager.removeItemAtPath(sourcePath, error: &error)
        if error? != nil {
            NSLog("Error removing downloaded file: \(error)")
        }

        // Run new app
        let cmd = "open \(destPath)"
        let task = NSTask.launchedTaskWithLaunchPath("/bin/sh", arguments: ["-c", cmd])
        task.waitUntilExit()

        exit(0)
    }
}
