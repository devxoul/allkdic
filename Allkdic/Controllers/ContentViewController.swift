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

import Cocoa
import SimpleCocoaAnalytics
import SnapKit
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
        self.view = NSView(frame: CGRect(x: 0, y: 0, width: 405, height: 566))
        self.view.autoresizingMask = .ViewNotSizable
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
            make.centerX.equalTo(0)
        }

        self.view.addSubview(self.hotKeyLabel)
        self.hotKeyLabel.textColor = NSColor.headerColor()
        self.hotKeyLabel.font = NSFont.systemFontOfSize(NSFont.smallSystemFontSize())
        self.hotKeyLabel.snp_makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp_bottom).offset(2)
            make.centerX.equalTo(0)
        }

        self.view.addSubview(self.separatorView)
        self.separatorView.image = NSImage(named: "line")
        self.separatorView.snp_makeConstraints { make in
            make.top.equalTo(self.hotKeyLabel.snp_bottom).offset(8)
            make.left.right.equalTo(0)
            make.height.equalTo(2)
        }

        self.view.addSubview(self.webView)
        self.webView.frameLoadDelegate = self
        self.webView.shouldUpdateWhileOffscreen = true
        self.webView.snp_makeConstraints { make in
            make.top.equalTo(self.separatorView.snp_bottom)
            make.left.right.bottom.equalTo(0)
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
        self.menuButton.bezelStyle = .RoundedDisclosureBezelStyle
        self.menuButton.setButtonType(.MomentaryPushInButton)
        self.menuButton.target = self
        self.menuButton.action = "showMenu"
        self.menuButton.snp_makeConstraints { make in
            make.right.equalTo(-10)
            make.centerY.equalTo(self.separatorView.snp_top).dividedBy(2)
        }

        let mainMenuItems = [
            NSMenuItem(title: "사전 바꾸기", action: nil, keyEquivalent: ""),
            NSMenuItem.separatorItem(),
            NSMenuItem(title: "올ㅋ사전에 관하여", action: "showAboutWindow", keyEquivalent: ""),
            NSMenuItem(title: "환경설정...", action: "showPreferenceWindow", keyEquivalent: ","),
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

        let selectedDictionary = DictionaryType.selectedDictionary

        // dictionary submenu
        for (i, dictionary) in enumerate(DictionaryType.allTypes) {
            let dictionaryMenuItem = NSMenuItem()
            dictionaryMenuItem.title = dictionary.title
            dictionaryMenuItem.tag = i
            dictionaryMenuItem.action = "swapDictionary:"
            dictionaryMenuItem.keyEquivalent = "\(i + 1)"
            dictionaryMenuItem.keyEquivalentModifierMask = Int(NSEventModifierFlags.CommandKeyMask.rawValue)
            if dictionary == selectedDictionary {
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
        self.javascript(DictionaryType.selectedDictionary.inputFocusingScript)
    }


    // MARK: - WebView

    func navigateToMain() {
        self.webView.mainFrameURL = DictionaryType.selectedDictionary.URLString
        self.indicator.startAnimation(self)
        self.indicator.hidden = false
    }

    override public func webView(sender: WebView!,
                                 willPerformClientRedirectToURL URL: NSURL!,
                                 delay seconds: NSTimeInterval,
                                 fireDate date: NSDate!,
                                 forFrame frame: WebFrame!) {
        let URLString = URL.absoluteString!
        if URLString.rangeOfString("query=") == nil && URLString.rangeOfString("q=") == nil {
            return
        }

        let URLPatternsForDictionaryType = [
            AnalyticsLabel.English:  ["endic", "eng", "ee"],
            AnalyticsLabel.Korean:   ["krdic", "kor"],
            AnalyticsLabel.Hanja:    ["hanja"],
            AnalyticsLabel.Japanese: ["jpdic", "jp"],
            AnalyticsLabel.Chinese:  ["cndic", "ch"],
            AnalyticsLabel.French:   ["frdic", "fr"],
            AnalyticsLabel.Russian:  ["ru"],
            AnalyticsLabel.Spanish:  ["spdic"],
        ]

        let URLPattern = DictionaryType.selectedDictionary.URLPattern
        let regex = NSRegularExpression(pattern: URLPattern, options: .CaseInsensitive, error: nil)!
        let result = regex.firstMatchInString(URLString, options: .allZeros, range: NSMakeRange(0, count(URLString)))
        if result == nil {
            return
        }
        let range = result!.rangeAtIndex(0)
        let pattern = (URLString as NSString).substringWithRange(range)

        for (type, patterns) in URLPatternsForDictionaryType {
            if contains(patterns, pattern) {
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
        return self.webView.mainFrameDocument?.evaluateWebScript(script)
    }

    public func handleKeyBinding(keyBinding: KeyBinding) {
        let key = (keyBinding.shift, keyBinding.control, keyBinding.option, keyBinding.command, keyBinding.keyCode)

        switch key {
        case (false, false, false, false, 53):
            // ESC
            PopoverController.sharedInstance().close()
            break

        case (_, false, false, true, let index) where 18...(18 + DictionaryType.allTypes.count) ~= index:
            // Command + [Shift] + 1, 2, 3, ...
            self.swapDictionary(index - 18)
            break

        case (false, false, false, true, KeyBinding.keyCodeFormKeyString(",")):
            // Command + ,
            self.showPreferenceWindow()
            break

        default:
            break
        }
    }


    // MARK: - Menu

    func showMenu() {
        self.mainMenu.popUpMenuPositioningItem(
            self.mainMenu.itemAtIndex(0),
            atLocation:self.menuButton.frame.origin,
            inView:self.view
        )
    }

    /// Swap dictionary to given index.
    ///
    /// :param: sender `Int` or `NSMenuItem`. If `NSMenuItem` is given, guess dictionary's index with `tag` property.
    func swapDictionary(sender: AnyObject?) {
        if sender == nil {
            return
        }

        var index: Int?
        if sender! is Int {
            index = sender! as? Int
        } else if sender! is NSMenuItem {
            index = sender!.tag()
        }

        if index == nil || index >= DictionaryType.allTypes.count {
            return
        }

        let selectedDictionary = DictionaryType.allTypes[index!]
        DictionaryType.selectedDictionary = selectedDictionary
        NSLog("Swap dictionary: \(selectedDictionary.name)")

        for menuItem in self.dictionaryMenu.itemArray {
            (menuItem as! NSMenuItem).state = NSOffState
        }
        self.dictionaryMenu.itemWithTag(index!)?.state = NSOnState

        AnalyticsHelper.sharedInstance().recordCachedEventWithCategory(
            AnalyticsCategory.Allkdic,
            action: AnalyticsAction.Dictionary,
            label: selectedDictionary.name,
            value: nil
        )

        self.navigateToMain()
    }

    func showPreferenceWindow() {
        PopoverController.sharedInstance().preferenceWindowController.showWindow(self)
    }

    func showAboutWindow() {
        PopoverController.sharedInstance().aboutWindowController.showWindow(self)
    }

    func quit() {
        exit(0)
    }
}
