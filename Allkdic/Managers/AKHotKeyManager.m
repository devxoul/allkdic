/*
 The MIT License (MIT)

 Copyright (c) 2013-2014 Suyeol Jeon (http://xoul.kr)

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
*/

#import "Allkdic-Swift.h"

#import <Carbon/Carbon.h>

#import "AKHotKeyManager.h"

@implementation AKHotKeyManager

/**
 * Reference : http://dbachrach.com/blog/2005/11/program-global-hotkeys-in-cocoa-easily/
 */
EventHotKeyRef hotKeyRef;

+ (void)registerHotKey
{
    EventHotKeyID hotKeyId;
    EventTypeSpec eventType;
    eventType.eventClass = kEventClassKeyboard;
    eventType.eventKind = kEventHotKeyPressed;

    // When hotkey event fired, hotKeyHandler is called.
    InstallApplicationEventHandler(&hotKeyHandler, 1, &eventType, NULL, NULL);

    // 4byte character
    hotKeyId.signature = 'allk';
    hotKeyId.id = 0;

    NSDictionary *data = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefaultsKey.HotKey];
    KeyBinding *keyBinding;
    if (data) {
        keyBinding = [[KeyBinding alloc] initWithDictionary:data];
    } else {
        NSLog(@"No existing key setting.");
        keyBinding = [[KeyBinding alloc] init];
        keyBinding.option = YES;
        keyBinding.command = YES;
        keyBinding.keyCode = 49; // Space
        [[NSUserDefaults standardUserDefaults] setObject:[keyBinding toDictionary] forKey:UserDefaultsKey.HotKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    NSLog(@"Bind HotKey : %@", keyBinding);

    UInt32 hotKeyModifiers = 0;
    if (keyBinding.shift) {
        hotKeyModifiers += shiftKey;
    }
    if (keyBinding.option) {
        hotKeyModifiers += optionKey;
    }
    if (keyBinding.control) {
        hotKeyModifiers += controlKey;
    }
    if (keyBinding.command) {
        hotKeyModifiers += cmdKey;
    }

    RegisterEventHotKey((UInt32)keyBinding.keyCode, hotKeyModifiers, hotKeyId, GetApplicationEventTarget(), 0,
                        &hotKeyRef);

    [[AllkdicManager sharedInstance].contentViewController updateHotKeyLabel];
}

+ (void)unregisterHotKey
{
    NSLog (@"Unbind HotKey");
    UnregisterEventHotKey(hotKeyRef);
}


#pragma mark -
#pragma mark HotKey

OSStatus hotKeyHandler(EventHandlerCallRef nextHandler, EventRef theEvent, void *userData)
{
    [[AllkdicManager sharedInstance] open];
    return noErr;
}

@end
