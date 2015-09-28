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

class AboutWindowController: WindowController {

    let logoView = NSImageView()
    let titleLabel = Label()
    let versionLabel = Label()
    let appstoreButton = NSButton()
    let viewOnGitHubButton = NSButton()
    let quitButton = NSButton()
    let copyrightLabel = Label()

    init() {
        super.init(windowSize: CGSizeMake(310, 408))
        self.window!.title = gettext("about")

        self.contentView.addSubview(logoView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(versionLabel)
        self.contentView.addSubview(appstoreButton)
        self.contentView.addSubview(viewOnGitHubButton)
        self.contentView.addSubview(quitButton)
        self.contentView.addSubview(copyrightLabel)


        self.logoView.image = NSImage(named: "AppIcon")
        self.logoView.snp_makeConstraints { make in
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(34)
            make.width.height.equalTo(87)
        }

        self.titleLabel.font = NSFont.boldSystemFontOfSize(23)
        self.titleLabel.textColor = NSColor.controlTextColor()
        self.titleLabel.stringValue = BundleInfo.BundleName
        self.titleLabel.sizeToFit()
        self.titleLabel.snp_makeConstraints { make in
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(self.logoView.snp_bottom).offset(10)
        }

        self.versionLabel.font = NSFont.systemFontOfSize(11)
        self.versionLabel.textColor = NSColor.headerColor()
        self.versionLabel.stringValue = gettext("version") + ": \(BundleInfo.Version)"
        self.versionLabel.sizeToFit()
        self.versionLabel.snp_makeConstraints { make in
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(self.titleLabel.snp_bottom).offset(10)
        }

        self.styleButton(self.appstoreButton)
        self.appstoreButton.title = gettext("open_in_appstore")
        self.appstoreButton.target = self
        self.appstoreButton.action = "openAppStore"
        self.appstoreButton.snp_makeConstraints { make in
            make.top.equalTo(self.versionLabel.snp_bottom).offset(15)
            make.centerX.equalTo(self.contentView)
            make.width.equalTo(156)
        }

        let credits = [
            (gettext("credit_developed_by"), gettext("전수열")),
            (gettext("credit_named_by"), gettext("하상욱")),
            (gettext("credit_thanks_to"), gettext("설진석") + gettext("thanks_to_chicken"))
        ]
        var keyLabels = [Label]()

        for (key, value) in credits {
            let keyLabel = Label()
            self.contentView.addSubview(keyLabel)
            keyLabel.alignment = .Right
            keyLabel.font = NSFont.boldSystemFontOfSize(NSFont.smallSystemFontSize())
            keyLabel.stringValue = key
            keyLabel.snp_makeConstraints { make in
                if keyLabels.count == 0 {
                    make.top.equalTo(self.appstoreButton.snp_bottom).offset(15)
                } else {
                    make.top.equalTo(keyLabels.last!.snp_bottom).offset(8)
                }
                make.left.equalTo(10)
                make.right.equalTo(self.contentView.snp_centerX).offset(-15)
            }
            keyLabels.append(keyLabel)

            let valueLabel = Label()
            self.contentView.addSubview(valueLabel)
            valueLabel.font = NSFont.systemFontOfSize(NSFont.smallSystemFontSize())
            valueLabel.stringValue = value
            valueLabel.snp_makeConstraints { make in
                make.top.equalTo(keyLabel)
                make.left.equalTo(keyLabel.snp_right).offset(4)
                make.right.equalTo(self.contentView).offset(-10)
            }
        }

        self.styleButton(self.viewOnGitHubButton)
        self.viewOnGitHubButton.title = gettext("view_on_github")
        self.viewOnGitHubButton.target = self
        self.viewOnGitHubButton.action = "viewOnGitHub"
        self.viewOnGitHubButton.snp_makeConstraints { make in
            make.top.equalTo(keyLabels.last!.snp_bottom).offset(15)
            make.centerX.equalTo(self.contentView)
            make.width.equalTo(self.appstoreButton)
        }

        self.styleButton(self.quitButton)
        self.quitButton.title = gettext("quit")
        self.quitButton.target = self
        self.quitButton.action = "quit"
        self.quitButton.snp_makeConstraints { make in
            make.top.equalTo(self.viewOnGitHubButton.snp_bottom).offset(10)
            make.centerX.equalTo(self.contentView)
            make.width.equalTo(self.appstoreButton)
        }

        self.copyrightLabel.textColor = NSColor.headerColor()
        self.copyrightLabel.font = NSFont.systemFontOfSize(9)
        self.copyrightLabel.stringValue = "Copyright © 2013 Suyeol Jeon. All Rights Reserved."
        self.copyrightLabel.snp_makeConstraints { make in
            make.top.equalTo(self.quitButton.snp_bottom).offset(20)
            make.centerX.equalTo(self.contentView)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func styleButton(button: NSButton) {
        button.setButtonType(.MomentaryPushInButton)
        button.bezelStyle = .RoundedBezelStyle
        button.font = NSFont.systemFontOfSize(NSFont.systemFontSizeForControlSize(.SmallControlSize))
        if #available(OSX 10.10, *) {
            button.controlSize = .SmallControlSize
        } else if let cell = button.cell as? NSButtonCell {
            cell.controlSize = .SmallControlSize
        }
    }

    override func showWindow(sender: AnyObject?) {
        super.showWindow(sender)
        PopoverController.sharedInstance().close()
        AnalyticsHelper.sharedInstance().recordScreenWithName("AboutWindow")
    }

    func openAppStore() {
        AnalyticsHelper.sharedInstance().recordCachedEventWithCategory(
            AnalyticsCategory.About,
            action: AnalyticsAction.CheckForUpdate,
            label: nil,
            value: nil
        )

        let appStoreID = "1033453958"
        let appStoreURLString = "macappstore://itunes.apple.com/app/id\(appStoreID)?mt=12"
        let appStoreURL = NSURL(string: appStoreURLString)!
        NSWorkspace.sharedWorkspace().openURL(appStoreURL)
    }

    func viewOnGitHub() {
        AnalyticsHelper.sharedInstance().recordCachedEventWithCategory(
            AnalyticsCategory.About,
            action: AnalyticsAction.ViewOnGitHub,
            label: nil,
            value: nil
        )
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: "https://github.com/devxoul/allkdic")!)
    }

    func quit() {
        exit(0)
    }
}
