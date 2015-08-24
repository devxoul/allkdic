// The MIT License (MIT)
//
// Copyright (c) 2013 Suyeol Jeon (http://xoul.kr)
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

import AppKit
import SimpleCocoaAnalytics
import Sparkle


class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(notification: NSNotification) {
        self.terminateAlreadyRunning()
        ApplicationFolder.moveToApplicationFolderIfNeeded()
        LoginItem.register()

        let ga = AnalyticsHelper.sharedInstance()
        ga.beginPeriodicReportingWithAccount("UA-42976442-2", name:"올ㅋ사전", version: BundleInfo.Version)

        PopoverController.sharedInstance()
        AKHotKeyManager.registerHotKey()

        self.checkForUpdatesInBackground()
        NSTimer.scheduledTimerWithTimeInterval(30 * 60,
            target: self,
            selector: "checkForUpdatesInBackground",
            userInfo: nil,
            repeats: true
        )
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

    func checkForUpdatesInBackground() {
        SUUpdater.sharedUpdater().checkForUpdatesInBackground()
    }
}
