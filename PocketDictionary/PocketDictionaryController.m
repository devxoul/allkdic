//
//  PocketDictionaryController.m
//  PocketDictionary
//
//  Created by 전수열 on 13. 8. 5..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "PocketDictionaryController.h"

@implementation PocketDictionaryController

- (id)initWithStatusItem:(NSStatusItem *)statusItem
{
	self = [super init];
	
	self.statusItem = statusItem;
	
	self.contentView = [[PocketDictionaryContentView alloc] init];
	
	self.popover = [[NSPopover alloc] init];
	self.popover.contentViewController = [[NSViewController alloc] init];
	self.popover.contentViewController.view = self.contentView;
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
	[self.contentView focusOnTextArea];
}

- (void)close
{
	NSButton *button = [self.statusItem valueForKey:@"_button"];
	button.state = NSOffState;
	
	[self.popover close];
}

@end
