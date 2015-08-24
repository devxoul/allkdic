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

import AppKit
import SimpleCocoaAnalytics
import SnapKit
import Sparkle

class AboutWindowController: WindowController {

    let logoView = NSImageView()
    let titleLabel = Label()
    let versionLabel = Label()
    let checkForUpdatesButton = NSButton()
    let viewOnGitHubButton = NSButton()
    let quitButton = NSButton()
    let copyrightLabel = Label()

    init() {
        super.init(windowSize: CGSizeMake(310, 408))
        self.window!.title = "올ㅋ사전에 관하여"

        self.contentView.addSubview(logoView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(versionLabel)
        self.contentView.addSubview(checkForUpdatesButton)
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
        self.titleLabel.stringValue = "올ㅋ사전"
        self.titleLabel.sizeToFit()
        self.titleLabel.snp_makeConstraints { make in
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(self.logoView.snp_bottom).offset(10)
        }

        self.versionLabel.font = NSFont.systemFontOfSize(11)
        self.versionLabel.textColor = NSColor.headerColor()
        self.versionLabel.stringValue = "버전: \(BundleInfo.Version)"
        self.versionLabel.sizeToFit()
        self.versionLabel.snp_makeConstraints { make in
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(self.titleLabel.snp_bottom).offset(10)
        }

        self.styleButton(self.checkForUpdatesButton)
        self.checkForUpdatesButton.title = "업데이트 확인..."
        self.checkForUpdatesButton.target = self
        self.checkForUpdatesButton.action = "checkForUpdates"
        self.checkForUpdatesButton.snp_makeConstraints { make in
            make.top.equalTo(self.versionLabel.snp_bottom).offset(15)
            make.centerX.equalTo(self.contentView)
            make.width.equalTo(156)
        }

        let credits = [
            ("개발", "전수열"),
            ("작명", "하상욱"),
            ("도움", "설진석 (치킨사줌)"),
        ]
        var keyLabels = [Label]()

        for (key, value) in credits {
            let keyLabel = Label()
            self.contentView.addSubview(keyLabel)
            keyLabel.alignment = .RightTextAlignment
            keyLabel.font = NSFont.boldSystemFontOfSize(NSFont.smallSystemFontSize())
            keyLabel.stringValue = key
            keyLabel.snp_makeConstraints { make in
                if keyLabels.count == 0 {
                    make.top.equalTo(self.checkForUpdatesButton.snp_bottom).offset(15)
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
        self.viewOnGitHubButton.title = "View on GitHub..."
        self.viewOnGitHubButton.target = self
        self.viewOnGitHubButton.action = "viewOnGitHub"
        self.viewOnGitHubButton.snp_makeConstraints { make in
            make.top.equalTo(keyLabels.last!.snp_bottom).offset(15)
            make.centerX.equalTo(self.contentView)
            make.width.equalTo(self.checkForUpdatesButton)
        }

        self.styleButton(self.quitButton)
        self.quitButton.title = "올ㅋ사전 종료"
        self.quitButton.target = self
        self.quitButton.action = "quit"
        self.quitButton.snp_makeConstraints { make in
            make.top.equalTo(self.viewOnGitHubButton.snp_bottom).offset(10)
            make.centerX.equalTo(self.contentView)
            make.width.equalTo(self.checkForUpdatesButton)
        }

        self.copyrightLabel.textColor = NSColor.headerColor()
        self.copyrightLabel.font = NSFont.systemFontOfSize(9)
        self.copyrightLabel.stringValue = "Copyright © 2013-2014 Suyeol Jeon. All Rights Reserved."
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
        if NSAppKitVersionNumberInt > NSAppKitVersionNumber10_9 {
            button.controlSize = .SmallControlSize
        } else if let cell = button.cell() as? NSButtonCell {
            cell.controlSize = .SmallControlSize
        }
    }

    override func showWindow(sender: AnyObject?) {
        super.showWindow(sender)
        PopoverController.sharedInstance().close()
        AnalyticsHelper.sharedInstance().recordScreenWithName("AboutWindow")
    }

    func checkForUpdates() {
        AnalyticsHelper.sharedInstance().recordCachedEventWithCategory(
            AnalyticsCategory.About,
            action: AnalyticsAction.CheckForUpdate,
            label: nil,
            value: nil
        )
        SUUpdater.sharedUpdater().checkForUpdates(self)
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
