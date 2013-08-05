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
//	NSRect statusItemFrame = [[self.statusItem valueForKey:@"window"] frame];
	
	self.panel = [[NSPanel alloc] init];
//	self.panel.contentSize = NSMakeSize( statusItemFrame.size.width, statusItemFrame.size.height );
	self.panel.contentSize = NSMakeSize( 405, 513 );
	self.panel.styleMask = NSBorderlessWindowMask | NSNonactivatingPanelMask;
	self.panel.collectionBehavior = NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorTransient;
	self.panel.hidesOnDeactivate = NO;
//	self.panel.opaque = NO;
//	self.panel.backgroundColor = [NSColor clearColor];
	self.panel.delegate = self;
	
	self.contentView = [[PocketDictionaryContentView alloc] init];
	
	self.popover = [[NSPopover alloc] init];
	self.popover.contentViewController = [[NSViewController alloc] init];
	self.popover.contentViewController.view = self.contentView;
	
	return self;
}

- (void)show
{
	NSRect statusItemFrame = [[self.statusItem valueForKey:@"window"] frame];
	[self.panel setFrameOrigin:NSMakePoint( statusItemFrame.origin.x, self.panel.screen.frame.size.height - self.statusItem.statusBar.thickness - 513 )];
	[self.panel orderFrontRegardless];
}

- (void)close
{
	
}

@end
