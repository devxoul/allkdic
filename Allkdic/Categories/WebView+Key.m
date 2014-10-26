//
//  WebView+Key.m
//  Allkdic
//
//  Created by 전수열 on 10/26/14.
//  Copyright (c) 2014 Joyfl. All rights reserved.
//

#import "WebView+Key.h"

@implementation WebView (Key)

- (BOOL)performKeyEquivalent:(NSEvent *)theEvent
{
    if (theEvent.modifierFlags & NSCommandKeyMask) {
        NSString *chars = theEvent.charactersIgnoringModifiers;

        if ([chars isEqualToString:@"a"]) {
            [self selectAll:self];
            return YES;
        }

        if ([chars isEqualToString:@"x"]) {
            [self cut:self];
            return YES;
        }

        if ([chars isEqualToString:@"c"]) {
            [self copy:self];
            return YES;
        }

        if ([chars isEqualToString:@"v"]) {
            [self paste:self];
            return YES;
        }
    }

    return [super performKeyEquivalent:theEvent];
}

@end
