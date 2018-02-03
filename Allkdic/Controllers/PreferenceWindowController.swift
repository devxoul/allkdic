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

class PreferenceWindowController: WindowController, NSTextFieldDelegate {

  var keyBinding: KeyBinding?

  let containerView = NSView()
  let label = Label()
  let hotKeyTextField = NSTextField()
  let shiftLabel = Label()
  let controlLabel = Label()
  let altLabel = Label()
  let commandLabel = Label()
  let keyLabel = Label()
  
  let autostartLabel = Label()
  let autostartCheckbox = NSButton()

  init() {
    super.init(windowSize: CGSize(width: 310, height: 200))
    self.window!.title = gettext("preferences")

    self.contentView.addSubview(self.containerView)
    
    self.containerView.addSubview(self.label)
    self.containerView.addSubview(self.hotKeyTextField)
    self.containerView.addSubview(self.shiftLabel)
    self.containerView.addSubview(self.controlLabel)
    self.containerView.addSubview(self.altLabel)
    self.containerView.addSubview(self.commandLabel)
    self.containerView.addSubview(self.keyLabel)
    self.containerView.addSubview(self.autostartLabel)
    self.containerView.addSubview(self.autostartCheckbox)

    self.containerView.snp.makeConstraints { make in
      make.margins.equalTo(0)
      make.height.greaterThanOrEqualTo(54)
      make.width.equalToSuperview()
      make.left.equalToSuperview()
      make.centerY.equalTo(self.contentView)
    }
    
    self.label.font = NSFont.systemFont(ofSize: 13)
    self.label.stringValue = gettext("shortcut") + ":"
    self.label.sizeToFit()
    self.label.snp.makeConstraints { make in
      make.left.equalTo(60)
      make.top.equalToSuperview().offset(5)
      make.centerY.equalTo(self.hotKeyTextField)
    }

    self.hotKeyTextField.delegate = self
    self.hotKeyTextField.font = NSFont.systemFont(ofSize: 13)
    self.hotKeyTextField.isSelectable = true
    self.hotKeyTextField.snp.makeConstraints { make in
      make.width.equalTo(140)
      make.height.equalTo(22)
      make.left.equalTo(self.label.snp.right).offset(5)
      make.top.equalToSuperview().offset(5)
    }

    self.shiftLabel.font = NSFont.systemFont(ofSize: 13)
    self.shiftLabel.stringValue = "⇧"
    self.shiftLabel.sizeToFit()
    self.shiftLabel.snp.makeConstraints { make in
      make.left.equalTo(self.hotKeyTextField).offset(4)
      make.centerY.equalTo(self.hotKeyTextField)
    }

    self.controlLabel.font = NSFont.systemFont(ofSize: 13)
    self.controlLabel.stringValue = "⌃"
    self.controlLabel.sizeToFit()
    self.controlLabel.snp.makeConstraints { make in
      make.left.equalTo(self.shiftLabel.snp.right).offset(-3)
      make.centerY.equalTo(self.hotKeyTextField)
    }

    self.altLabel.font = NSFont.systemFont(ofSize: 13)
    self.altLabel.stringValue = "⌥"
    self.altLabel.sizeToFit()
    self.altLabel.snp.makeConstraints { make in
      make.left.equalTo(self.controlLabel.snp.right).offset(-3)
      make.centerY.equalTo(self.hotKeyTextField)
    }

    self.commandLabel.font = NSFont.systemFont(ofSize: 13)
    self.commandLabel.stringValue = "⌘"
    self.commandLabel.sizeToFit()
    self.commandLabel.snp.makeConstraints { make in
      make.left.equalTo(self.altLabel.snp.right).offset(-3)
      make.centerY.equalTo(self.hotKeyTextField)
    }

    self.keyLabel.font = NSFont.systemFont(ofSize: 13)
    self.keyLabel.snp.makeConstraints { make in
      make.left.equalTo(self.commandLabel.snp.right).offset(-3)
      make.centerY.equalTo(self.hotKeyTextField)
    }
    
    self.autostartLabel.font = NSFont.systemFont(ofSize: 13)
    self.autostartLabel.stringValue = gettext("launch_at_login") + ":"
    self.autostartLabel.sizeToFit()
    self.autostartLabel.snp.makeConstraints { make in
      make.left.equalTo(self.label.snp.left)
      make.centerY.equalTo(self.autostartCheckbox.snp.centerY)
    }
    
    self.autostartCheckbox.target = self
    self.autostartCheckbox.title = ""
    self.autostartCheckbox.state = LoginItem.enabled ? .on : .off
    self.autostartCheckbox.action = #selector(toggleAutostart(_:))
    self.autostartCheckbox.setButtonType(.switch)
    self.autostartCheckbox.snp.makeConstraints { make in
      make.right.equalTo(hotKeyTextField.snp.right)
      make.height.equalTo(22)
      make.top.equalTo(self.hotKeyTextField.snp.bottom).offset(5)
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func showWindow(_ sender: Any?) {
    super.showWindow(sender)

    AKHotKeyManager.unregisterHotKey()

    let keyBindingData = UserDefaults.standard.dictionary(forKey: UserDefaultsKey.hotKey)
    let keyBinding = KeyBinding(dictionary: keyBindingData)
    self.handleKeyBinding(keyBinding)

    AnalyticsHelper.sharedInstance().recordScreen(withName: "PreferenceWindow")
  }

  func windowShouldClose(_ sender: AnyObject?) -> Bool {
    AKHotKeyManager.registerHotKey()
    return true
  }

  override func controlTextDidChange(_ notification: Notification) {
    if notification.object as? NSTextField == self.hotKeyTextField {
      self.hotKeyTextField.stringValue = ""
    }
  }

  func handleKeyBinding(_ keyBinding: KeyBinding?) {
    guard let keyBinding = keyBinding,
      self.keyBinding != keyBinding,
      keyBinding.shift || keyBinding.control || keyBinding.option || keyBinding.command
    else { return }

    self.keyBinding = keyBinding
    self.shiftLabel.textColor = NSColor.lightGray
    self.controlLabel.textColor = NSColor.lightGray
    self.altLabel.textColor = NSColor.lightGray
    self.commandLabel.textColor = NSColor.lightGray

    if keyBinding.shift {
      self.shiftLabel.textColor = NSColor.black
    }
    if keyBinding.control {
      self.controlLabel.textColor = NSColor.black
    }
    if keyBinding.option {
      self.altLabel.textColor = NSColor.black
    }
    if keyBinding.command {
      self.commandLabel.textColor = NSColor.black
    }

    guard let keyString = KeyBinding.keyStringFormKeyCode(keyBinding.keyCode) else { return }
    self.keyLabel.stringValue = keyString.capitalized
    self.keyLabel.sizeToFit()

    UserDefaults.standard.set(keyBinding.toDictionary(), forKey: UserDefaultsKey.hotKey)
    UserDefaults.standard.synchronize()

    PopoverController.sharedInstance().contentViewController.updateHotKeyLabel()

    AnalyticsHelper.sharedInstance().recordCachedEvent(
      withCategory: AnalyticsCategory.preference,
      action: AnalyticsAction.updateHotKey,
      label: nil,
      value: nil
    )
  }
  
  @objc func toggleAutostart(_ sender: AnyObject) -> Void {
    LoginItem.setEnabled(enabled: self.autostartCheckbox.state == .on)
  }
}
