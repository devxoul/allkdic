//
//  AllkdicController.m
//  Allkdic
//
//  Created by 전수열 on 13. 8. 5..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "AllkdicController.h"

@implementation AllkdicController

- (id)initWithStatusItem:(NSStatusItem *)statusItem
{
	self = [super init];
	
	self.statusItem = statusItem;
	
	self.popover = [[NSPopover alloc] init];
	self.popover.contentViewController = [[AlldicContentViewController alloc] initWithNibName:@"AlldicContentView" bundle:nil];
	[NSEvent addGlobalMonitorForEventsMatchingMask:NSLeftMouseUp | NSLeftMouseDown handler:^(NSEvent *event)
	{
		[self close];
	}];
	
	[NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:^(NSEvent *event) {
		[self handleKeyCode:event.keyCode flags:event.modifierFlags];
		return event;
	}];
	
    return self;
}

- (void)open
{
	NSButton *button = [self.statusItem valueForKey:@"_button"];
	
	if( self.popover.isShown )
	{
		[self close];
		return;
	}
	
	button.state = NSOnState;
	
	[NSApp activateIgnoringOtherApps:YES];
	[self.popover showRelativeToRect:NSZeroRect ofView:button preferredEdge:NSMaxYEdge];
	[self.contentViewController focusOnTextArea];
}

- (void)close
{
	NSButton *button = [self.statusItem valueForKey:@"_button"];
	button.state = NSOffState;
	
	[self.popover close];
}

- (void)handleKeyCode:(unsigned short)keyCode flags:(NSUInteger)flag
{
	BOOL control = NO;
	BOOL shift = NO;
	BOOL command = NO;
	BOOL alt = NO;
	
	for( int i = 0; i < 6; i ++ )
	{
		if( flag & (1 << i) )
		{
			if( i == 0 ) {
				control = YES;
			} else if( i == 1 ) {
				shift = YES;
			} else if( i == 3 ) {
				command = YES;
			} else if( i == 5 ) {
				alt = YES;
			}
		}
	}
	
	NSLog( @"keys : %d, %d, %d, %d, %d", keyCode, control, shift, command, alt );
}

@end
