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

import Cocoa
import Snappy
import WebKit

public class ContentViewController: NSViewController {

    let titleLabel = LabelButton()
    let hotKeyLabel = Label()
    let separatorView = NSImageView()
    let webView = WebView()
    let indicator = NSProgressIndicator(frame: NSZeroRect)
    let menuButton = NSButton()
    let mainMenu = NSMenu()

    override public func loadView() {
        self.view = NSView(frame: CGRectMake(0, 0, 405, 566))

        self.view.addSubview(self.titleLabel)
        self.titleLabel.textColor = NSColor.controlTextColor()
        self.titleLabel.font = NSFont.systemFontOfSize(16)
        self.titleLabel.stringValue = "올ㅋ사전"
        self.titleLabel.sizeToFit()
        self.titleLabel.target = self
        self.titleLabel.action = "navigateToMain"
        self.titleLabel.snp_makeConstraints { make in
            make.top.equalTo(10)
            make.centerX.equalTo(self.view)
        }

        self.view.addSubview(self.hotKeyLabel)
        self.hotKeyLabel.textColor = NSColor.headerColor()
        self.hotKeyLabel.font = NSFont.systemFontOfSize(NSFont.smallSystemFontSize())
        self.hotKeyLabel.snp_makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp_bottom).with.offset(2)
            make.centerX.equalTo(self.view)
        }

        self.view.addSubview(self.separatorView)
        self.separatorView.image = NSImage(named: "line")
        self.separatorView.snp_makeConstraints { make in
            make.top.equalTo(self.hotKeyLabel.snp_bottom).with.offset(8)
            make.centerX.equalTo(self.view)
            make.width.equalTo(self.view)
            make.height.equalTo(2)
        }

        self.view.addSubview(self.webView)
        self.webView.frameLoadDelegate = self
        self.webView.shouldUpdateWhileOffscreen = true
        self.webView.snp_makeConstraints { make in
            make.top.equalTo(self.separatorView.snp_bottom)
            make.left.right.and.bottom.equalTo(self.view)
        }

        self.view.addSubview(self.indicator)
        self.indicator.style = .SpinningStyle
        self.indicator.controlSize = .SmallControlSize
        self.indicator.displayedWhenStopped = false
        self.indicator.sizeToFit()
        self.indicator.snp_makeConstraints { make in
            make.center.equalTo(self.webView)
            return
        }

        self.view.addSubview(self.menuButton)
        self.menuButton.title = ""
        self.menuButton.bezelStyle = .HelpButtonBezelStyle
        self.menuButton.setButtonType(.MomentaryPushInButton)
        self.menuButton.target = self
        self.menuButton.action = "showMenu"
        self.menuButton.snp_makeConstraints { make in
            make.right.equalTo(self.view).with.offset(-10)
            make.centerY.equalTo(self.separatorView.snp_top).dividedBy(2)
        }

        let menuItems = [
            NSMenuItem(title: "환경설정", action: "showPreferenceWindow", keyEquivalent: ""),
            NSMenuItem(title: "올ㅋ사전에 관하여", action: "showAboutWindow", keyEquivalent: ""),
            NSMenuItem.separatorItem(),
            NSMenuItem(title: "올ㅋ사전 종료", action: "quit", keyEquivalent: ""),
        ]
        for menuItem in menuItems {
            self.mainMenu.addItem(menuItem)
        }

        self.navigateToMain()
    }

    public func updateHotKeyLabel() {
        let keyBindingData = NSUserDefaults.standardUserDefaults().dictionaryForKey(UserDefaultsKey.HotKey)
        let keyBinding = KeyBinding(dictionary: keyBindingData)

        var keys = [String]()
        if keyBinding.shift {
            keys.append("Shift")
        }
        if keyBinding.control {
            keys.append("Control")
        }
        if keyBinding.option {
            keys.append("Option")
        }
        if keyBinding.command {
            keys.append("Command")
        }
        keys.append(KeyBinding.keyStringFormKeyCode(CGKeyCode(keyBinding.keyCode)).capitalizedString)
        self.hotKeyLabel.stringValue = " + ".join(keys)
        self.hotKeyLabel.sizeToFit()
    }

    public func focusOnTextArea() {
        self.javascript("ac_input.focus()")
        self.javascript("ac_input.select()")
    }


    // MARK: - WebView

    func navigateToMain() {
        self.webView.mainFrameURL = "http://endic.naver.com/popManager.nhn?m=miniPopMain"
        self.indicator.startAnimation(self)
        self.indicator.hidden = false
    }

    override public func webView(sender: WebView!,
        willPerformClientRedirectToURL URL: NSURL!,
        delay seconds: NSTimeInterval,
        fireDate date: NSDate!,
        forFrame frame: WebFrame!) {

        let URLString = URL.absoluteString! as NSString
        if !URLString.containsString("query=") {
            return
        }

        let dictionaryTypesForPrefix = [
            "endic": AnalyticsValue.English,
            "krdic": AnalyticsValue.Korean,
            "hanja": AnalyticsValue.Hanja,
            "jpdic": AnalyticsValue.Japanese,
            "cndic": AnalyticsValue.Chinese,
            "frdic": AnalyticsValue.French,
        ]

        for (prefix, type) in dictionaryTypesForPrefix {
            if URLString.hasPrefix("http://\(prefix)") {
                AnalyticsHelper.sharedInstance().recordCachedEventWithCategory(
                    AnalyticsCategory.Allkdic,
                    action: AnalyticsAction.Search,
                    label: type,
                    value: nil
                )
                break
            }
        }
    }

    override public func webView(sender: WebView!, didFinishLoadForFrame frame: WebFrame!) {
        self.indicator.stopAnimation(self)
        self.indicator.hidden = true
        self.focusOnTextArea()
    }

    func javascript(script: String) -> AnyObject? {
        if self.webView.mainFrameDocument? == nil {
            return nil
        }
        return self.webView.mainFrameDocument!.evaluateWebScript(script)
    }

    public func handleKeyBinding(keyBinding: KeyBinding) {
        let key = (keyBinding.shift, keyBinding.control, keyBinding.option, keyBinding.command, keyBinding.keyCode)

        switch key {
        case (false, false, false, false, 53):
            // ESC
            AllkdicManager.sharedInstance().close()
            break

        default:
            break
        }
    }


    // MARK: - Menu

    func showMenu() {
        self.mainMenu.popUpMenuPositioningItem(self.mainMenu.itemAtIndex(0), atLocation:self.menuButton.frame.origin, inView:self.view)
    }

    func showPreferenceWindow() {
        AllkdicManager.sharedInstance().preferenceWindowController.showWindow(self)
    }

    func showAboutWindow() {
        AllkdicManager.sharedInstance().aboutWindowController.showWindow(self)
    }

    func quit() {
        exit(0)
    }
}
