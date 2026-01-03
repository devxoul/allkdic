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
import SnapKit

final class ContentViewController: NSViewController {

  let headerView = NSVisualEffectView()
  let titleLabel = LabelButton()
  let hotKeyLabel = Label()
  let separatorView = NSBox()
  let webView = WKWebView()
  let indicator = NSProgressIndicator(frame: .zero)
  let menuButton = NSButton()
  let mainMenu = NSMenu()
  let dictionaryMenu = NSMenu()

  override func loadView() {
    let contentSize = CGSize(width: 420, height: 580)
    self.view = NSView(frame: CGRect(origin: .zero, size: contentSize))
    self.view.translatesAutoresizingMaskIntoConstraints = false
    self.preferredContentSize = contentSize

    self.view.widthAnchor.constraint(equalToConstant: 420).isActive = true
    self.view.heightAnchor.constraint(equalToConstant: 580).isActive = true

    self.view.addSubview(self.headerView)
    self.headerView.material = .headerView
    self.headerView.blendingMode = .withinWindow
    self.headerView.state = .active
    self.headerView.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
      make.height.equalTo(64)
    }

    self.headerView.addSubview(self.titleLabel)
    self.titleLabel.textColor = NSColor.labelColor
    self.titleLabel.font = NSFont.systemFont(ofSize: 17, weight: .semibold)
    self.titleLabel.stringValue = BundleInfo.bundleName
    self.titleLabel.sizeToFit()
    self.titleLabel.target = self
    self.titleLabel.action = #selector(ContentViewController.navigateToMain)
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalTo(14)
      make.centerX.equalToSuperview()
    }

    self.headerView.addSubview(self.hotKeyLabel)
    self.hotKeyLabel.textColor = NSColor.secondaryLabelColor
    self.hotKeyLabel.font = NSFont.systemFont(ofSize: 12, weight: .regular)
    self.hotKeyLabel.snp.makeConstraints { make in
      make.top.equalTo(self.titleLabel.snp.bottom).offset(4)
      make.centerX.equalToSuperview()
    }

    self.headerView.addSubview(self.menuButton)
    self.menuButton.image = NSImage(systemSymbolName: "gearshape", accessibilityDescription: "Settings")
    self.menuButton.imagePosition = .imageOnly
    self.menuButton.isBordered = false
    self.menuButton.contentTintColor = NSColor.secondaryLabelColor
    self.menuButton.target = self
    self.menuButton.action = #selector(ContentViewController.showMenu)
    self.menuButton.snp.makeConstraints { make in
      make.right.equalTo(-14)
      make.centerY.equalToSuperview()
      make.width.height.equalTo(24)
    }

    self.view.addSubview(self.separatorView)
    self.separatorView.boxType = .separator
    self.separatorView.snp.makeConstraints { make in
      make.top.equalTo(self.headerView.snp.bottom)
      make.left.right.equalToSuperview()
      make.height.equalTo(1)
    }

    self.view.addSubview(self.webView)
    self.webView.navigationDelegate = self
    self.webView.snp.makeConstraints { make in
      make.top.equalTo(self.separatorView.snp.bottom)
      make.left.right.bottom.equalToSuperview()
    }

    self.view.addSubview(self.indicator)
    self.indicator.style = .spinning
    self.indicator.controlSize = .regular
    self.indicator.isDisplayedWhenStopped = false
    self.indicator.sizeToFit()
    self.indicator.snp.makeConstraints { make in
      make.center.equalTo(self.webView)
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

    mainMenuItems[0].submenu = self.dictionaryMenu

    let selectedDictionary = DictionaryType.selectedDictionary

    for (i, dictionary) in DictionaryType.allTypes.enumerated() {
      let dictionaryMenuItem = NSMenuItem()
      dictionaryMenuItem.title = dictionary.title
      dictionaryMenuItem.tag = i
      dictionaryMenuItem.action = #selector(ContentViewController.swapDictionary(_:))
      dictionaryMenuItem.keyEquivalent = "\(i + 1)"
      dictionaryMenuItem.keyEquivalentModifierMask = .command
      if dictionary == selectedDictionary {
        dictionaryMenuItem.state = .on
      }
      self.dictionaryMenu.addItem(dictionaryMenuItem)
    }

    self.navigateToMain()
  }

  @objc func updateHotKeyLabel() {
    let keyBindingData = UserDefaults.standard.dictionary(forKey: UserDefaultsKey.hotKey)
    let keyBinding = KeyBinding(dictionary: keyBindingData)
    self.hotKeyLabel.stringValue = keyBinding.description
    self.hotKeyLabel.sizeToFit()
  }

  @objc func focusOnTextArea() {
    let script = DictionaryType.selectedDictionary.inputFocusingScript
    self.webView.evaluateJavaScript(script, completionHandler: nil)
  }

  @objc func navigateToMain() {
    guard let url = URL(string: DictionaryType.selectedDictionary.URLString) else { return }
    let request = URLRequest(url: url)
    self.webView.load(request)
    self.indicator.startAnimation(self)
    self.indicator.isHidden = false
  }

  func handleKeyBinding(_ keyBinding: KeyBinding) {
    let key = (keyBinding.shift, keyBinding.control, keyBinding.option, keyBinding.command, keyBinding.keyCode)

    switch key {
    case (false, false, false, false, 53):
      PopoverController.shared.close()

    case (_, false, false, true, let index) where 18...(18 + DictionaryType.allTypes.count) ~= index:
      self.swapDictionary(index - 18)

    case (false, false, false, true, KeyBinding.keyCodeFormKeyString(",")):
      self.showPreferenceWindow()

    default:
      break
    }
  }

  @objc func showMenu() {
    self.mainMenu.popUp(
      positioning: self.mainMenu.item(at: 0),
      at: self.menuButton.frame.origin,
      in: self.headerView
    )
  }

  @objc func swapDictionary(_ sender: Any?) {
    if sender == nil {
      return
    }

    guard let index = (sender as? Int) ?? (sender as? NSMenuItem)?.tag,
      index < DictionaryType.allTypes.count
    else { return }

    let selectedDictionary = DictionaryType.allTypes[index]
    DictionaryType.selectedDictionary = selectedDictionary
    NSLog("Swap dictionary: \(selectedDictionary.name)")

    for menuItem in self.dictionaryMenu.items {
      menuItem.state = .off
    }
    self.dictionaryMenu.item(withTag: index)?.state = .on

    self.navigateToMain()
  }

  @objc func showPreferenceWindow() {
    PopoverController.shared.preferenceWindowController.showWindow(self)
  }

  @objc func showAboutWindow() {
    PopoverController.shared.aboutWindowController.showWindow(self)
  }

  @objc func quit() {
    exit(0)
  }
}

extension ContentViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    self.indicator.stopAnimation(self)
    self.indicator.isHidden = true
    self.focusOnTextArea()
  }
}
