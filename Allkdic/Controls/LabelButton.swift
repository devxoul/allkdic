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

public class LabelButton: Label {

    public var normalTextColor: NSColor! = NSColor.blackColor()
    public var highlightedTextColor: NSColor! = NSColor(white: 0.5, alpha: 1)

    override public func mouseDown(theEvent: NSEvent?) {
        self.textColor = self.highlightedTextColor
    }

    override public func mouseUp(theEvent: NSEvent?) {
        self.textColor = self.normalTextColor

        if let event = theEvent {
            let point = event.locationInWindow
            let rect = CGRectInset(self.frame, -10, -30)

            if NSPointInRect(point, rect) {
                self.sendAction(self.action, to: self.target)
            }
        }
    }
}