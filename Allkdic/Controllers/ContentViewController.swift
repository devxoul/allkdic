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
    let dictionaryMenu = NSMenu()

    override public func loadView() {
        self.view = NSView(frame: CGRectMake(0, 0, 405, 566))
        self.view.appearance = NSAppearance(named: NSAppearanceNameAqua)

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

        let mainMenuItems = [
            NSMenuItem(title: "사전", action: nil, keyEquivalent: ""),
            NSMenuItem(title: "환경설정", action: "showPreferenceWindow", keyEquivalent: ""),
            NSMenuItem(title: "올ㅋ사전에 관하여", action: "showAboutWindow", keyEquivalent: ""),
            NSMenuItem.separatorItem(),
            NSMenuItem(title: "올ㅋ사전 종료", action: "quit", keyEquivalent: ""),
        ]

        for mainMenuItem in mainMenuItems {
            self.mainMenu.addItem(mainMenuItem)
        }

        //
        // Dictionary Sub Menu
        //
        mainMenuItems[0].submenu = self.dictionaryMenu

        let dictionaryKeyModifierMask = Int(
            NSEventModifierFlags.CommandKeyMask.rawValue | NSEventModifierFlags.ShiftKeyMask.rawValue
        )

        let userDefaults = NSUserDefaults.standardUserDefaults()
        var selectedDictionaryName = userDefaults.stringForKey(UserDefaultsKey.SelectedDictionaryName)
        if selectedDictionaryName? == nil {
            selectedDictionaryName = DictionaryName.Naver
            userDefaults.setValue(selectedDictionaryName, forKey: UserDefaultsKey.SelectedDictionaryName)
            userDefaults.synchronize()
        }

        for (i, info) in enumerate(DictionaryInfo) {
            let dictionaryMenuItem = NSMenuItem()
            dictionaryMenuItem.title = info[DictionaryInfoKey.Title]!
            dictionaryMenuItem.tag = i
            dictionaryMenuItem.action = "swapDictionary:"
            dictionaryMenuItem.keyEquivalent = "\(i + 1)"
            dictionaryMenuItem.keyEquivalentModifierMask = dictionaryKeyModifierMask
            if selectedDictionaryName == info[DictionaryInfoKey.Name] {
                dictionaryMenuItem.state = NSOnState
            }
            self.dictionaryMenu.addItem(dictionaryMenuItem)
        }
        self.navigateToMain()
    }

    public func updateHotKeyLabel() {
        let keyBindingData = NSUserDefaults.standardUserDefaults().dictionaryForKey(UserDefaultsKey.HotKey)
        let keyBinding = KeyBinding(dictionary: keyBindingData)
        self.hotKeyLabel.stringValue = keyBinding.description
        self.hotKeyLabel.sizeToFit()
    }

    public func focusOnTextArea() {
        self.javascript("ac_input.focus()")
        self.javascript("ac_input.select()")
    }


    // MARK: - WebView

    func navigateToMain() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let selectedDictionaryName = userDefaults.stringForKey(UserDefaultsKey.SelectedDictionaryName)
        let selectedDictionary = DictionaryInfo.filter {
            return $0[DictionaryInfoKey.Name] == selectedDictionaryName
        }[0]
        let URL = selectedDictionary[DictionaryInfoKey.URL]

        self.webView.mainFrameURL = URL
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
            "endic": AnalyticsLabel.English,
            "krdic": AnalyticsLabel.Korean,
            "hanja": AnalyticsLabel.Hanja,
            "jpdic": AnalyticsLabel.Japanese,
            "cndic": AnalyticsLabel.Chinese,
            "frdic": AnalyticsLabel.French,
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

        case (true, false, false, true, let index) where 18...(18 + DictionaryInfo.count) ~= index:
            self.swapDictionary(index - 18)
            break

        default:
            break
        }
    }


    // MARK: - Menu

    func showMenu() {
        self.mainMenu.popUpMenuPositioningItem(self.mainMenu.itemAtIndex(0), atLocation:self.menuButton.frame.origin, inView:self.view)
    }

    /// Swap dictionary to given index.
    ///
    /// :param: sender `Int` or `NSMenuItem`. If `NSMenuItem` is given, guess dictionary's index with `tag` property.
    func swapDictionary(sender: AnyObject?) {
        if sender? == nil {
            return
        }

        var index: Int?
        if sender! is Int {
            index = sender! as? Int
        } else if sender! is NSMenuItem {
            index = sender!.tag()
        }

        if index? == nil {
            return
        }

        let selectedDictionary = DictionaryInfo[index!]
        let dictionaryName = selectedDictionary[DictionaryInfoKey.Name]!

        let userDefaults = NSUserDefaults.standardUserDefaults()
        if dictionaryName == userDefaults.stringForKey(UserDefaultsKey.SelectedDictionaryName) {
            return
        }
        userDefaults.setValue(dictionaryName, forKey: UserDefaultsKey.SelectedDictionaryName)
        userDefaults.synchronize()

        NSLog("Swap dictionary: \(dictionaryName)")

        for menuItem in self.dictionaryMenu.itemArray {
            (menuItem as NSMenuItem).state = NSOffState
        }
        self.dictionaryMenu.itemWithTag(index!)?.state = NSOnState

        AnalyticsHelper.sharedInstance().recordCachedEventWithCategory(
            AnalyticsCategory.Allkdic,
            action: AnalyticsAction.Dictionary,
            label: dictionaryName,
            value: nil
        )

        self.navigateToMain()
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
