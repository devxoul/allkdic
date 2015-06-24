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

/**
 * http://stackoverflow.com/questions/815063/how-do-you-make-your-app-open-at-login
 */

#import "LoginUtil.h"

@implementation LoginUtil

+ (BOOL)willStartAtLogin
{
    return YES;
//	NSURL *itemURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
//	
//    Boolean foundIt=false;
//    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
//    if (loginItems) {
//        UInt32 seed = 0U;
//        NSArray *currentLoginItems = [NSMakeCollectable(LSSharedFileListCopySnapshot(loginItems, &seed)) autorelease];
//        for (id itemObject in currentLoginItems) {
//            LSSharedFileListItemRef item = (LSSharedFileListItemRef)itemObject;
//			
//            UInt32 resolutionFlags = kLSSharedFileListNoUserInteraction | kLSSharedFileListDoNotMountVolumes;
//            CFURLRef URL = NULL;
//            OSStatus err = LSSharedFileListItemResolve(item, resolutionFlags, &URL, /*outRef*/ NULL);
//            if (err == noErr) {
//                foundIt = CFEqual(URL, itemURL);
//                CFRelease(URL);
//				
//                if (foundIt)
//                    break;
//            }
//        }
//        CFRelease(loginItems);
//    }
//    return (BOOL)foundIt;
}

+ (void)setStartAtLoginEnabled:(BOOL)enabled
{
//	NSURL *itemURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
//	
////    OSStatus status;
//    LSSharedFileListItemRef existingItem = NULL;
//	
//    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
//    if (loginItems) {
//        UInt32 seed = 0U;
//        NSArray *currentLoginItems = [NSMakeCollectable(LSSharedFileListCopySnapshot(loginItems, &seed)) autorelease];
//        for (id itemObject in currentLoginItems) {
//            LSSharedFileListItemRef item = (LSSharedFileListItemRef)itemObject;
//			
//            UInt32 resolutionFlags = kLSSharedFileListNoUserInteraction | kLSSharedFileListDoNotMountVolumes;
//            CFURLRef URL = NULL;
//            OSStatus err = LSSharedFileListItemResolve(item, resolutionFlags, &URL, /*outRef*/ NULL);
//            if (err == noErr) {
//                Boolean foundIt = CFEqual(URL, itemURL);
//                CFRelease(URL);
//				
//                if (foundIt) {
//                    existingItem = item;
//                    break;
//                }
//            }
//        }
//		
//        if (enabled && (existingItem == NULL)) {
//            LSSharedFileListInsertItemURL(loginItems, kLSSharedFileListItemBeforeFirst,
//                                          NULL, NULL, (CFURLRef)itemURL, NULL, NULL);
//			
//        } else if (!enabled && (existingItem != NULL))
//            LSSharedFileListItemRemove(loginItems, existingItem);
//		
//        CFRelease(loginItems);
//    }       
}

@end
