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
import WebKit

import SimpleCocoaAnalytics

open class ContentViewController: NSViewController {

    let titleLabel = LabelButton()
    let hotKeyLabel = Label()
    let separatorView = NSImageView()
    let webView = WebView()
    let indicator = NSProgressIndicator(frame: NSZeroRect)
    let menuButton = NSButton()
    let mainMenu = NSMenu()
    let dictionaryMenu = NSMenu()

    override open func loadView() {
        self.view = NSView(frame: CGRect(x: 0, y: 0, width: 405, height: 566))
        self.view.autoresizingMask = NSAutoresizingMaskOptions()
        self.view.appearance = NSAppearance(named: NSAppearanceNameAqua)

        self.view.addSubview(self.titleLabel)
        self.titleLabel.textColor = NSColor.controlTextColor
        self.titleLabel.font = NSFont.systemFont(ofSize: 16)
        self.titleLabel.stringValue = BundleInfo.BundleName
        self.titleLabel.sizeToFit()
        self.titleLabel.target = self
        self.titleLabel.action = #selector(ContentViewController.navigateToMain)
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.centerX.equalTo(0)
        }

        self.view.addSubview(self.hotKeyLabel)
        self.hotKeyLabel.textColor = NSColor.headerColor
        self.hotKeyLabel.font = NSFont.systemFont(ofSize: NSFont.smallSystemFontSize())
        self.hotKeyLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(2)
            make.centerX.equalTo(0)
        }

        self.view.addSubview(self.separatorView)
        self.separatorView.image = NSImage(named: "line")
        self.separatorView.snp.makeConstraints { make in
            make.top.equalTo(self.hotKeyLabel.snp.bottom).offset(8)
            make.left.right.equalTo(0)
            make.height.equalTo(2)
        }

        self.view.addSubview(self.webView)
        self.webView.frameLoadDelegate = self
        self.webView.shouldUpdateWhileOffscreen = true
        self.webView.snp.makeConstraints { make in
            make.top.equalTo(self.separatorView.snp.bottom)
            make.left.right.bottom.equalTo(0)
        }

        self.view.addSubview(self.indicator)
        self.indicator.style = .spinningStyle
        self.indicator.controlSize = .small
        self.indicator.isDisplayedWhenStopped = false
        self.indicator.sizeToFit()
        self.indicator.snp.makeConstraints { make in
            make.center.equalTo(self.webView)
            return
        }

        self.view.addSubview(self.menuButton)
        self.menuButton.title = ""
        self.menuButton.bezelStyle = .roundedDisclosure
        self.menuButton.setButtonType(.momentaryPushIn)
        self.menuButton.target = self
        self.menuButton.action = #selector(ContentViewController.showMenu)
        self.menuButton.snp.makeConstraints { make in
            make.right.equalTo(-10)
            make.centerY.equalTo(self.separatorView.snp.top).dividedBy(2)
        }

        let mainMenuItems = [
            NSMenuItem(title: gettext("change_dictionary"), action: nil, keyEquivalent: ""),
            NSMenuItem.separator(),
            NSMenuItem(title: gettext("about"), action: #selector(ContentViewController.showAboutWindow), keyEquivalent: ""),
            NSMenuItem(title: gettext("preferences") + "...", action: #selector(ContentViewController.showPreferenceWindow), keyEquivalent: ","),
            NSMenuItem.separator(),
            NSMenuItem(title: gettext("quit"), action: #selector(ContentViewController.quit), keyEquivalent: ""),
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
        for (i, dictionary) in DictionaryType.allTypes.enumerated() {
            let dictionaryMenuItem = NSMenuItem()
            dictionaryMenuItem.title = dictionary.title
            dictionaryMenuItem.tag = i
            dictionaryMenuItem.action = #selector(ContentViewController.swapDictionary(_:))
            dictionaryMenuItem.keyEquivalent = "\(i + 1)"
            dictionaryMenuItem.keyEquivalentModifierMask = .command
            if dictionary == selectedDictionary {
                dictionaryMenuItem.state = NSOnState
            }
            self.dictionaryMenu.addItem(dictionaryMenuItem)
        }

        self.navigateToMain()
    }

    open func updateHotKeyLabel() {
        let keyBindingData = UserDefaults.standard.dictionary(forKey: UserDefaultsKey.HotKey)
        let keyBinding = KeyBinding(dictionary: keyBindingData)
        self.hotKeyLabel.stringValue = keyBinding.description
        self.hotKeyLabel.sizeToFit()
    }

    open func focusOnTextArea() {
        self.javascript(DictionaryType.selectedDictionary.inputFocusingScript)
    }


    // MARK: - WebView

    func navigateToMain() {
        self.webView.mainFrameURL = DictionaryType.selectedDictionary.URLString
        self.indicator.startAnimation(self)
        self.indicator.isHidden = false
    }

    @discardableResult
    func javascript(_ script: String) -> AnyObject? {
        return self.webView.mainFrameDocument?.evaluateWebScript(script) as AnyObject?
    }

    open func handleKeyBinding(_ keyBinding: KeyBinding) {
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
        self.mainMenu.popUp(
            positioning: self.mainMenu.item(at: 0),
            at:self.menuButton.frame.origin,
            in:self.view
        )
    }

    /// Swap dictionary to given index.
    ///
    /// - parameter sender: `Int` or `NSMenuItem`. If `NSMenuItem` is given, guess dictionary's index with `tag`
    ///                     property.
    func swapDictionary(_ sender: Any?) {
        if sender == nil {
            return
        }

        guard let index = (sender as? Int) ?? (sender as? NSMenuItem)?.tag,
            index >= DictionaryType.allTypes.count else { return }

        if index == nil || index >= DictionaryType.allTypes.count {
            return
        }

        let selectedDictionary = DictionaryType.allTypes[index]
        DictionaryType.selectedDictionary = selectedDictionary
        NSLog("Swap dictionary: \(selectedDictionary.name)")

        for menuItem in self.dictionaryMenu.items {
            menuItem.state = NSOffState
        }
        self.dictionaryMenu.item(withTag: index)?.state = NSOnState

        AnalyticsHelper.sharedInstance().recordCachedEvent(
            withCategory: AnalyticsCategory.Allkdic,
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


// MARK: - WebFrameLoadDelegate

extension ContentViewController: WebFrameLoadDelegate {

    public func webView(_ sender: WebView!,
                        willPerformClientRedirectTo URL: URL!,
                        delay seconds: TimeInterval,
                        fire date: Date!,
                        for frame: WebFrame!) {
        let URLString = URL.absoluteString
        if URLString.range(of: "query=") == nil && URLString.range(of: "q=") == nil {
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
        let regex = try! NSRegularExpression(pattern: URLPattern, options: .caseInsensitive)
        let regexRange = NSMakeRange(0, URLString.characters.count)
        guard let result = regex.firstMatch(in: URLString, options: [], range: regexRange) else {
            return
        }
        let range = result.rangeAt(0)
        let pattern = (URLString as NSString).substring(with: range)

        for (type, patterns) in URLPatternsForDictionaryType {
            if patterns.contains(pattern) {
                AnalyticsHelper.sharedInstance().recordCachedEvent(
                    withCategory: AnalyticsCategory.Allkdic,
                    action: AnalyticsAction.Search,
                    label: type,
                    value: nil
                )
                break
            }
        }
    }

    public func webView(_ sender: WebView!, didFinishLoadFor frame: WebFrame!) {
        self.indicator.stopAnimation(self)
        self.indicator.isHidden = true
        self.focusOnTextArea()
    }

}
