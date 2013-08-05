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
	self.popover.behavior = NSPopoverBehaviorTransient;
	[NSEvent addGlobalMonitorForEventsMatchingMask:NSLeftMouseUp handler:^(NSEvent *event)
	{
		[self close];
	}];
	
	return self;
}

- (void)open
{
	[NSApp activateIgnoringOtherApps:YES];
	[self.popover showRelativeToRect:NSZeroRect ofView:[self.statusItem valueForKey:@"_button"] preferredEdge:NSMaxYEdge];
	[self.contentView focusOnTextArea];
}

- (void)close
{
	[self.popover close];
}

@end
