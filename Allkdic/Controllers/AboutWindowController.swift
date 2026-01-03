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

final class AboutWindowController: WindowController {

  let mainStack = NSStackView()
  let logoView = NSImageView()
  let titleLabel = Label()
  let versionLabel = Label()
  let buttonStack = NSStackView()
  let appstoreButton = NSButton()
  let viewOnGitHubButton = NSButton()
  let creditsStack = NSStackView()
  let separatorView = NSBox()
  let footerStack = NSStackView()
  let quitButton = NSButton()
  let copyrightLabel = Label()

  init() {
    super.init(windowSize: CGSize(width: 340, height: 420))
    self.window?.title = gettext("about")

    self.mainStack.orientation = .vertical
    self.mainStack.spacing = 12
    self.mainStack.alignment = .centerX
    self.mainStack.edgeInsets = NSEdgeInsets(top: 64, left: 24, bottom: 24, right: 24)
    self.contentView.addSubview(self.mainStack)
    self.mainStack.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    self.logoView.image = NSImage(named: "AppIcon")
    self.logoView.imageScaling = .scaleProportionallyUpOrDown
    self.logoView.snp.makeConstraints { make in
      make.width.height.equalTo(96)
    }
    self.mainStack.addArrangedSubview(self.logoView)

    self.titleLabel.font = NSFont.systemFont(ofSize: 22, weight: .semibold)
    self.titleLabel.textColor = NSColor.labelColor
    self.titleLabel.stringValue = BundleInfo.bundleName
    self.titleLabel.sizeToFit()
    self.mainStack.addArrangedSubview(self.titleLabel)
    self.mainStack.setCustomSpacing(12, after: self.logoView)

    self.versionLabel.font = NSFont.systemFont(ofSize: 12, weight: .regular)
    self.versionLabel.textColor = NSColor.secondaryLabelColor
    self.versionLabel.stringValue = gettext("version") + " \(BundleInfo.version)"
    self.versionLabel.sizeToFit()
    self.mainStack.addArrangedSubview(self.versionLabel)
    self.mainStack.setCustomSpacing(2, after: self.titleLabel)

    self.buttonStack.orientation = .horizontal
    self.buttonStack.spacing = 8
    self.mainStack.addArrangedSubview(self.buttonStack)
    self.mainStack.setCustomSpacing(16, after: self.versionLabel)

    self.styleButton(self.appstoreButton, primary: true)
    self.appstoreButton.title = gettext("open_in_appstore")
    self.appstoreButton.target = self
    self.appstoreButton.action = #selector(AboutWindowController.openAppStore)
    self.buttonStack.addArrangedSubview(self.appstoreButton)

    self.styleButton(self.viewOnGitHubButton, primary: false)
    self.viewOnGitHubButton.title = gettext("view_on_github")
    self.viewOnGitHubButton.image = NSImage(systemSymbolName: "arrow.up.right", accessibilityDescription: nil)
    self.viewOnGitHubButton.imagePosition = .imageTrailing
    self.viewOnGitHubButton.target = self
    self.viewOnGitHubButton.action = #selector(AboutWindowController.viewOnGitHub)
    self.buttonStack.addArrangedSubview(self.viewOnGitHubButton)

    self.separatorView.boxType = .separator
    self.mainStack.addArrangedSubview(self.separatorView)
    self.separatorView.snp.makeConstraints { make in
      make.width.equalToSuperview().offset(-48)
    }
    self.mainStack.setCustomSpacing(16, after: self.buttonStack)

    self.creditsStack.orientation = .vertical
    self.creditsStack.spacing = 8
    self.creditsStack.alignment = .leading
    self.mainStack.addArrangedSubview(self.creditsStack)
    self.mainStack.setCustomSpacing(16, after: self.separatorView)

    let credits = [
      (gettext("credit_developed_by"), gettext("전수열")),
      (gettext("credit_named_by"), gettext("하상욱")),
      (gettext("credit_thanks_to"), gettext("설진석") + gettext("thanks_to_chicken"))
    ]

    for (key, value) in credits {
      let row = NSStackView()
      row.orientation = .horizontal
      row.spacing = 8
      row.alignment = .firstBaseline
      
      let keyLabel = Label()
      keyLabel.font = NSFont.systemFont(ofSize: 11, weight: .medium)
      keyLabel.textColor = NSColor.secondaryLabelColor
      keyLabel.stringValue = key
      keyLabel.alignment = .right
      keyLabel.snp.makeConstraints { make in
        make.width.equalTo(80)
      }
      row.addArrangedSubview(keyLabel)

      let valueLabel = Label()
      valueLabel.font = NSFont.systemFont(ofSize: 11, weight: .regular)
      valueLabel.textColor = NSColor.labelColor
      valueLabel.stringValue = value
      row.addArrangedSubview(valueLabel)

      self.creditsStack.addArrangedSubview(row)
    }

    self.footerStack.orientation = .vertical
    self.footerStack.spacing = 12
    self.footerStack.alignment = .centerX
    self.mainStack.addArrangedSubview(self.footerStack)
    self.mainStack.setCustomSpacing(20, after: self.creditsStack)

    self.styleButton(self.quitButton, primary: false)
    self.quitButton.title = gettext("quit")
    self.quitButton.target = self
    self.quitButton.action = #selector(AboutWindowController.quit)
    self.footerStack.addArrangedSubview(self.quitButton)

    self.copyrightLabel.textColor = NSColor.tertiaryLabelColor
    self.copyrightLabel.font = NSFont.systemFont(ofSize: 10, weight: .regular)
    self.copyrightLabel.stringValue = "© 2013-2026 Suyeol Jeon"
    self.footerStack.addArrangedSubview(self.copyrightLabel)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func styleButton(_ button: NSButton, primary: Bool) {
    button.setButtonType(.momentaryPushIn)
    button.bezelStyle = .rounded
    button.font = NSFont.systemFont(ofSize: 12, weight: .medium)
    button.controlSize = .regular
    if primary {
      button.keyEquivalent = "\r"
    }
  }

  override func showWindow(_ sender: Any?) {
    super.showWindow(sender)
    PopoverController.shared.close()
  }

  @objc func openAppStore() {
    let appStoreID = "1033453958"
    let appStoreURLString = "macappstore://itunes.apple.com/app/id\(appStoreID)?mt=12"
    if let appStoreURL = URL(string: appStoreURLString) {
      NSWorkspace.shared.open(appStoreURL)
    }
  }

  @objc func viewOnGitHub() {
    if let url = URL(string: "https://github.com/devxoul/allkdic") {
      NSWorkspace.shared.open(url)
    }
  }

  @objc func quit() {
    exit(0)
  }
}
