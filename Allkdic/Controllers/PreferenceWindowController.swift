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

class PreferenceWindowController: WindowController, NSTextFieldDelegate {

    var keyBinding: KeyBinding?

    let label = Label()
    let hotKeyTextField = NSTextField()
    let shiftLabel = Label()
    let controlLabel = Label()
    let altLabel = Label()
    let commandLabel = Label()
    let keyLabel = Label()

    init() {
        super.init(windowSize: CGSizeMake(310, 200))
        self.window!.title = "환경설정"

        self.contentView.addSubview(self.label)
        self.contentView.addSubview(self.hotKeyTextField)
        self.contentView.addSubview(self.shiftLabel)
        self.contentView.addSubview(self.controlLabel)
        self.contentView.addSubview(self.altLabel)
        self.contentView.addSubview(self.commandLabel)
        self.contentView.addSubview(self.keyLabel)

        self.label.font = NSFont.systemFontOfSize(13)
        self.label.stringValue = "단축키:"
        self.label.sizeToFit()
        self.label.snp_makeConstraints { make in
            make.left.equalTo(60)
            make.centerY.equalTo(self.contentView)
        }

        self.hotKeyTextField.delegate = self
        self.hotKeyTextField.font = NSFont.systemFontOfSize(13)
        self.hotKeyTextField.selectable = true
        self.hotKeyTextField.snp_makeConstraints { make in
            make.width.equalTo(140)
            make.height.equalTo(22)
            make.left.equalTo(self.label.snp_right).with.offset(5)
            make.centerY.equalTo(self.contentView)
        }

        self.shiftLabel.font = NSFont.systemFontOfSize(13)
        self.shiftLabel.stringValue = "⇧"
        self.shiftLabel.sizeToFit()
        self.shiftLabel.snp_makeConstraints { make in
            make.left.equalTo(self.hotKeyTextField).with.offset(4)
            make.centerY.equalTo(self.hotKeyTextField)
        }

        self.controlLabel.font = NSFont.systemFontOfSize(13)
        self.controlLabel.stringValue = "⌃"
        self.controlLabel.sizeToFit()
        self.controlLabel.snp_makeConstraints { make in
            make.left.equalTo(self.shiftLabel.snp_right).with.offset(-3)
            make.centerY.equalTo(self.hotKeyTextField)
        }

        self.altLabel.font = NSFont.systemFontOfSize(13)
        self.altLabel.stringValue = "⌥"
        self.altLabel.sizeToFit()
        self.altLabel.snp_makeConstraints { make in
            make.left.equalTo(self.controlLabel.snp_right).with.offset(-3)
            make.centerY.equalTo(self.hotKeyTextField)
        }

        self.commandLabel.font = NSFont.systemFontOfSize(13)
        self.commandLabel.stringValue = "⌘"
        self.commandLabel.sizeToFit()
        self.commandLabel.snp_makeConstraints { make in
            make.left.equalTo(self.altLabel.snp_right).with.offset(-3)
            make.centerY.equalTo(self.hotKeyTextField)
        }

        self.keyLabel.font = NSFont.systemFontOfSize(13)
        self.keyLabel.snp_makeConstraints { make in
            make.left.equalTo(self.commandLabel.snp_right).with.offset(-3)
            make.centerY.equalTo(self.hotKeyTextField)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func showWindow(sender: AnyObject?) {
        super.showWindow(sender)

        AKHotKeyManager.unregisterHotKey()

        let keyBindingData = NSUserDefaults.standardUserDefaults().dictionaryForKey(UserDefaultsKey.HotKey)
        let keyBinding = KeyBinding(dictionary: keyBindingData)
        self.handleKeyBinding(keyBinding)

        AnalyticsHelper.sharedInstance().recordScreenWithName("PreferenceWindow")
    }

    func windowShouldClose(sender: AnyObject?) -> Bool {
        AKHotKeyManager.registerHotKey()
        return true
    }

    override func controlTextDidChange(notification: NSNotification?) {
        if notification? == nil {
            return
        }
        let textField = notification?.object as NSTextField
        if textField == self.hotKeyTextField {
            textField.stringValue = ""
        }
    }

    func handleKeyBinding(keyBinding: KeyBinding) {
        if !keyBinding.shift && !keyBinding.control && !keyBinding.option && !keyBinding.command {
            return
        }

        if self.keyBinding == keyBinding {
            return
        }

        self.keyBinding = keyBinding
        self.shiftLabel.textColor = NSColor.lightGrayColor()
        self.controlLabel.textColor = NSColor.lightGrayColor()
        self.altLabel.textColor = NSColor.lightGrayColor()
        self.commandLabel.textColor = NSColor.lightGrayColor()

        if keyBinding.shift {
            self.shiftLabel.textColor = NSColor.blackColor()
        }
        if keyBinding.control {
            self.controlLabel.textColor = NSColor.blackColor()
        }
        if keyBinding.option {
            self.altLabel.textColor = NSColor.blackColor()
        }
        if keyBinding.command {
            self.commandLabel.textColor = NSColor.blackColor()
        }

        self.keyLabel.stringValue = KeyBinding.keyStringFormKeyCode(CGKeyCode(keyBinding.keyCode)).capitalizedString
        self.keyLabel.sizeToFit()

        NSUserDefaults.standardUserDefaults().setObject(keyBinding.dictionary, forKey: UserDefaultsKey.HotKey)
        NSUserDefaults.standardUserDefaults().synchronize()

        AllkdicManager.sharedInstance().contentViewController.updateHotKeyLabel()

        AnalyticsHelper.sharedInstance().recordCachedEventWithCategory(
            AnalyticsCategory.Preference,
            action: AnalyticsAction.UpdateHotKey,
            label:nil,
            value:nil
        )
    }
}
