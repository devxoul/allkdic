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

private let _sharedInstance = PopoverController()

open class PopoverController: NSObject {

    fileprivate let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    fileprivate var statusButton: NSButton {
        return self.statusItem.value(forKey: "_button") as! NSButton
    }
    fileprivate let popover = NSPopover()

    internal let contentViewController = ContentViewController()
    internal let preferenceWindowController = PreferenceWindowController()
    internal let aboutWindowController = AboutWindowController()


    open class func sharedInstance() -> PopoverController {
        return _sharedInstance
    }


    public override init() {
        super.init()

        let icon = NSImage(named: "statusicon_default")
        icon?.isTemplate = true
        self.statusItem.image = icon
        self.statusItem.target = self
        self.statusItem.action = #selector(PopoverController.open)

        self.statusButton.focusRingType = .none
        self.statusButton.setButtonType(.pushOnPushOff)

        self.popover.contentViewController = self.contentViewController

        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseUp, .leftMouseDown]) { _ in
            self.close()
        }

        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            self.handleKeyCode(event.keyCode, flags: event.modifierFlags, windowNumber: event.windowNumber)
            return event
        }
    }

    open func open() {
        if self.popover.isShown {
            self.close()
            return
        }

        self.statusButton.state = NSOnState

        NSApp.activate(ignoringOtherApps: true)
        self.popover.show(relativeTo: .zero, of: self.statusButton, preferredEdge: .maxY)
        self.contentViewController.updateHotKeyLabel()
        self.contentViewController.focusOnTextArea()

        AnalyticsHelper.sharedInstance().recordScreen(withName: "AllkdicWindow")
        AnalyticsHelper.sharedInstance().recordCachedEvent(
            withCategory: AnalyticsCategory.Allkdic,
            action: AnalyticsAction.Open,
            label: nil,
            value: nil
        )
    }

    open func close() {
        if !self.popover.isShown {
            return
        }

        self.statusButton.state = NSOffState
        self.popover.close()

        AnalyticsHelper.sharedInstance().recordCachedEvent(
            withCategory: AnalyticsCategory.Allkdic,
            action: AnalyticsAction.Close,
            label: nil,
            value: nil
        )
    }

    open func handleKeyCode(_ keyCode: UInt16, flags: NSEventModifierFlags, windowNumber: Int) {
        let keyBinding = KeyBinding(keyCode: Int(keyCode), flags: Int(flags.rawValue))

        if let window = NSApp.window(withWindowNumber: windowNumber) {
            if ["NSStatusBarWindow", "_NSPopoverWindow"].contains(type(of: window).className()) {
                self.contentViewController.handleKeyBinding(keyBinding)
            } else if let windowController = window.windowController as? PreferenceWindowController {
                windowController.handleKeyBinding(keyBinding)
            }
        }
    }
}
