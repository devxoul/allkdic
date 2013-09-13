//
//  AllkdicWindowController.m
//  Allkdic
//
//  Created by 전수열 on 13. 9. 14..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "AllkdicWindowController.h"

@implementation AllkdicWindowController

- (void)windowDidLoad
{
	[self.window close];
}

// Abstract
- (void)handleKeyBinding:(KeyBinding *)keyBinding {}

@end
