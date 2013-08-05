//
//  NSWindow+CanBecomeKeyWindow.m
//  PocketDictionary
//
//  Created by 전수열 on 13. 8. 5..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "NSWindow+CanBecomeKeyWindow.h"

@implementation NSWindow (CanBecomeKeyWindow)

// NSPopover의 window가 Key Window가 될 수 있어야 popover 안에 있는 control들을 사용가능함.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (BOOL)canBecomeKeyWindow
{
	return YES;
}

#pragma clang diagnostic pop

@end
