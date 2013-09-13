//
//  AllkdicWindowController.h
//  Allkdic
//
//  Created by 전수열 on 13. 9. 14..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KeyBinding.h"

@interface AllkdicWindowController : NSWindowController

// Abstract
- (void)handleKeyBinding:(KeyBinding *)keyBinding;

@end
