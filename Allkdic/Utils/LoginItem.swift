// The MIT License (MIT)
//
// Copyright (c) 2015 Suyeol Jeon (http://xoul.kr)
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


open class LoginItem {

    fileprivate static var URL: Foundation.URL {
        return Foundation.URL(fileURLWithPath: Bundle.main.bundlePath)
    }

    fileprivate class var loginItemsList: LSSharedFileList {
        let type = kLSSharedFileListSessionLoginItems.takeUnretainedValue()
        let list = LSSharedFileListCreate(nil, type, nil).takeUnretainedValue()
        return list
    }

    fileprivate class var loginItems: [LSSharedFileListItem] {
        let list = self.loginItemsList
        let items = LSSharedFileListCopySnapshot(list, nil).takeUnretainedValue() as? [LSSharedFileListItem]
        return items ?? []
    }

    fileprivate class var loginItem: LSSharedFileListItem? {
        for item in self.loginItems {
            var URLRef: Unmanaged<CFURL>?
            let error = LSSharedFileListItemResolve(item, LSSharedFileListResolutionFlags(0), &URLRef, nil)
            if let URLRef = URLRef , error == noErr && CFEqual(URLRef.takeUnretainedValue(), self.URL as CFTypeRef!) {
                return item
            }
        }
        return nil
    }

    open class func registered() -> Bool {
        return self.loginItem != nil
    }

    open class func register() {
        if self.loginItem == nil {
            let beforeItem = kLSSharedFileListItemBeforeFirst.takeUnretainedValue()
            let displayName = BundleInfo.BundleName as CFString
            let URL = self.URL as CFURL
            LSSharedFileListInsertItemURL(self.loginItemsList, beforeItem, displayName, nil, URL, nil, nil)
        }
    }

    open class func unregister() {
        if let loginItem = self.loginItem {
            LSSharedFileListItemRemove(self.loginItemsList, loginItem)
        }
    }

}
