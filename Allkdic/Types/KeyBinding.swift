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

private let _dictionaryKeys = ["keyCode", "shift", "control", "option", "command"]

public func ==(left: KeyBinding, right: KeyBinding) -> Bool {
    for key in _dictionaryKeys {
        if left.valueForKey(key) as? Int != right.valueForKey(key) as? Int {
            return false
        }
    }
    return true
}

@objc public class KeyBinding: NSObject {

    var keyCode: Int = 0
    var shift: Bool = false
    var control: Bool = false
    var option: Bool = false
    var command: Bool = false

    override public var description: String {
        var keys = [String]()
        if self.shift {
            keys.append("Shift")
        }
        if self.control {
            keys.append("Control")
        }
        if self.option {
            keys.append("Option")
        }
        if self.command {
            keys.append("Command")
        }

        if let keyString = self.dynamicType.keyStringFormKeyCode(self.keyCode) {
            keys.append(keyString.capitalizedString)
        }

        return keys.joinWithSeparator(" + ")
    }

    @objc public override init() {
        super.init()
    }

    @objc public init(keyCode: Int, flags: Int) {
        super.init()
        self.keyCode = keyCode
        for i in 0...6 {
            if flags & (1 << i) != 0 {
                if i == 0 {
                    self.control = true
                } else if i == 1 {
                    self.shift = true
                } else if i == 3 {
                    self.command = true
                } else if i == 5 {
                    self.option = true
                }
            }
        }
    }

    @objc public init(dictionary: [NSObject: AnyObject]?) {
        super.init()
        if dictionary == nil {
            return
        }
        for key in _dictionaryKeys {
            if let value = dictionary![key] as? Int {
                self.setValue(value, forKey: key)
            }
        }
    }

    public func toDictionary() -> [String: Int] {
        var dictionary = [String: Int]()
        for key in _dictionaryKeys {
            dictionary[key] = self.valueForKey(key)!.integerValue
        }
        return dictionary
    }

    public class func keyStringFormKeyCode(keyCode: Int) -> String? {
        return keyMap[keyCode]
    }

    public class func keyCodeFormKeyString(string: String) -> Int {
        for (keyCode, keyString) in keyMap {
            if keyString == string {
                return keyCode
            }
        }
        return NSNotFound
    }
}
