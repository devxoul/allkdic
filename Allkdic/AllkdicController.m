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

@end
