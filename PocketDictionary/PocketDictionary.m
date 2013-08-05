//
//  PocketDictionary.m
//  PocketDictionary
//
//  Created by 전수열 on 13. 8. 5..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "PocketDictionary.h"

@implementation PocketDictionary

- (id)initWithStatusItem:(NSStatusItem *)statusItem
{
	self = [super init];
	
	self.statusItem = statusItem;
	NSRect statusItemFrame = [[self.statusItem valueForKey:@"window"] frame];
	
	self.window = [[NSWindow alloc] init];
	self.window.contentSize = NSMakeSize( statusItemFrame.size.width, statusItemFrame.size.height );
	self.window.styleMask = NSBorderlessWindowMask;
	self.window.collectionBehavior = NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorTransient;
	self.window.hidesOnDeactivate = YES;
	self.window.opaque = YES;
	self.window.alphaValue = 0;
	
	self.contentView = [[PocketDictionaryContentView alloc] init];
	
	self.popover = [[NSPopover alloc] init];
	self.popover.contentViewController = [[NSViewController alloc] init];
	self.popover.contentViewController.view = self.contentView;
	[self.popover showRelativeToRect:NSMakeRect( 0, 0, 405, 513 ) ofView:self.window.contentView preferredEdge:NSMinYEdge];
	
	return self;
}

- (void)show
{
	NSRect statusItemFrame = [[self.statusItem valueForKey:@"window"] frame];
	[self.window setFrameOrigin:NSMakePoint( statusItemFrame.origin.x, self.window.screen.frame.size.height - self.statusItem.statusBar.thickness - 2 )];
	
	[self.popover close];
	[self.popover showRelativeToRect:NSMakeRect( 0, 0, 405, 513 ) ofView:self.window.contentView preferredEdge:NSMinYEdge];
	
	[self.window makeKeyAndOrderFront:nil];
	[NSApp activateIgnoringOtherApps:YES];
}

@end
