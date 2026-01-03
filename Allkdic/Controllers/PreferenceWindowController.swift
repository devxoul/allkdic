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
import SnapKit

final class PreferenceWindowController: WindowController, NSTextFieldDelegate {

  var keyBinding: KeyBinding?

  let containerView = NSView()
  let label = Label()
  let hotKeyContainer = NSView()
  let hotKeyTextField = NSTextField()
  let modifierStack = NSStackView()
  let shiftLabel = Label()
  let controlLabel = Label()
  let altLabel = Label()
  let commandLabel = Label()
  let keyLabel = Label()
  let autostartLabel = Label()
  let autostartCheckbox = NSSwitch()

  init() {
    super.init(windowSize: CGSize(width: 380, height: 160))
    self.window!.title = gettext("preferences")

    self.contentView.addSubview(self.containerView)
    self.containerView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(10)
    }

    self.label.font = NSFont.systemFont(ofSize: 13, weight: .regular)
    self.label.textColor = NSColor.labelColor
    self.label.alignment = .right
    self.label.stringValue = gettext("shortcut")
    self.containerView.addSubview(self.label)
    self.label.snp.makeConstraints { make in
      make.top.left.equalToSuperview()
      make.width.equalTo(110)
    }

    self.hotKeyContainer.wantsLayer = true
    self.hotKeyContainer.layer?.backgroundColor = NSColor.controlBackgroundColor.cgColor
    self.hotKeyContainer.layer?.cornerRadius = 6
    self.hotKeyContainer.layer?.borderWidth = 1
    self.hotKeyContainer.layer?.borderColor = NSColor.separatorColor.cgColor
    self.containerView.addSubview(self.hotKeyContainer)
    self.hotKeyContainer.snp.makeConstraints { make in
      make.left.equalTo(self.label.snp.right).offset(12)
      make.centerY.equalTo(self.label)
      make.width.equalTo(180)
      make.height.equalTo(28)
    }

    self.hotKeyTextField.delegate = self
    self.hotKeyTextField.isBordered = false
    self.hotKeyTextField.backgroundColor = .clear
    self.hotKeyTextField.font = NSFont.systemFont(ofSize: 13)
    self.hotKeyTextField.isSelectable = true
    self.hotKeyContainer.addSubview(self.hotKeyTextField)
    self.hotKeyTextField.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    self.modifierStack.orientation = .horizontal
    self.modifierStack.spacing = 4
    self.modifierStack.alignment = .centerY
    self.hotKeyContainer.addSubview(self.modifierStack)
    self.modifierStack.snp.makeConstraints { make in
      make.left.equalTo(10)
      make.centerY.equalToSuperview()
    }

    for (label, symbol) in [(self.shiftLabel, "⇧"), (self.controlLabel, "⌃"), (self.altLabel, "⌥"), (self.commandLabel, "⌘")] {
      label.font = NSFont.systemFont(ofSize: 14, weight: .medium)
      label.stringValue = symbol
      label.textColor = NSColor.tertiaryLabelColor
      label.sizeToFit()
      self.modifierStack.addArrangedSubview(label)
    }

    self.keyLabel.font = NSFont.systemFont(ofSize: 13, weight: .medium)
    self.keyLabel.textColor = NSColor.labelColor
    self.modifierStack.addArrangedSubview(self.keyLabel)

    self.autostartLabel.font = NSFont.systemFont(ofSize: 13, weight: .regular)
    self.autostartLabel.textColor = NSColor.labelColor
    self.autostartLabel.alignment = .right
    self.autostartLabel.stringValue = gettext("launch_at_login")
    self.containerView.addSubview(self.autostartLabel)
    self.autostartLabel.snp.makeConstraints { make in
      make.top.equalTo(self.label.snp.bottom).offset(20)
      make.left.equalToSuperview()
      make.width.equalTo(self.label)
      make.bottom.equalToSuperview()
    }

    self.autostartCheckbox.target = self
    self.autostartCheckbox.state = LoginItem.enabled ? .on : .off
    self.autostartCheckbox.action = #selector(toggleAutostart(_:))
    self.containerView.addSubview(self.autostartCheckbox)
    self.autostartCheckbox.snp.makeConstraints { make in
      make.left.equalTo(self.hotKeyContainer)
      make.centerY.equalTo(self.autostartLabel)
    }

    self.hotKeyContainer.snp.makeConstraints { make in
      make.right.equalToSuperview()
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
  }

  func windowShouldClose(_ sender: NSWindow) -> Bool {
    AKHotKeyManager.registerHotKey()
    return true
  }

  func controlTextDidChange(_ notification: Notification) {
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
    self.shiftLabel.textColor = NSColor.tertiaryLabelColor
    self.controlLabel.textColor = NSColor.tertiaryLabelColor
    self.altLabel.textColor = NSColor.tertiaryLabelColor
    self.commandLabel.textColor = NSColor.tertiaryLabelColor

    if keyBinding.shift {
      self.shiftLabel.textColor = NSColor.labelColor
    }
    if keyBinding.control {
      self.controlLabel.textColor = NSColor.labelColor
    }
    if keyBinding.option {
      self.altLabel.textColor = NSColor.labelColor
    }
    if keyBinding.command {
      self.commandLabel.textColor = NSColor.labelColor
    }

    guard let keyString = KeyBinding.keyStringFormKeyCode(keyBinding.keyCode) else { return }
    self.keyLabel.stringValue = keyString.capitalized
    self.keyLabel.sizeToFit()

    UserDefaults.standard.set(keyBinding.toDictionary(), forKey: UserDefaultsKey.hotKey)
    UserDefaults.standard.synchronize()

    PopoverController.shared.contentViewController.updateHotKeyLabel()
  }

  @objc func toggleAutostart(_ sender: AnyObject) {
    LoginItem.setEnabled(self.autostartCheckbox.state == .on)
  }
}
