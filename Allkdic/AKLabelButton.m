//
//  AKLabelButton.m
//  Allkdic
//
//  Created by 전수열 on 9/26/14.
//  Copyright (c) 2014 Joyfl. All rights reserved.
//

#import "AKLabelButton.h"

@implementation AKLabelButton

- (void)mouseDown:(NSEvent *)theEvent
{
    self.textColor = self.highlightedTextColor ?: [NSColor colorWithWhite:0.5 alpha:1];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    self.textColor = self.normalTextColor ?: [NSColor colorWithWhite:0 alpha:1];

    NSPoint point = theEvent.locationInWindow;
    CGRect rect = CGRectInset(self.frame, -10, -30);

    if (NSPointInRect(point, rect)) {
        [self sendAction:self.action to:self.target];
    }
}

@end
