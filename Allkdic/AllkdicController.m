//
//  AllkdicController.m
//  Allkdic
//
//  Created by 전수열 on 13. 8. 5..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "AllkdicController.h"
#import "AppDelegate.h"
#import "AllkdicWindowController.h"
#import "KeyBinding.h"

@implementation AllkdicController

+ (AllkdicController *)sharedController
{
	return [(AppDelegate *)[NSApplication sharedApplication].delegate allkdicController];
}

- (id)initWithStatusItem:(NSStatusItem *)statusItem
{
	self = [super init];
	
	self.statusItem = statusItem;
	
	self.contentViewController = [[AlldicContentViewController alloc] initWithNibName:@"AlldicContentView" bundle:nil];
	self.preferenceWindowController = [[PreferenceWindowController alloc] initWithWindowNibName:@"PreferenceWindow"];
	self.aboutWindowController = [[AboutWindowController alloc] initWithWindowNibName:@"AboutWindow"];
	
	self.popover = [[NSPopover alloc] init];
	self.popover.contentViewController = self.contentViewController;
	[NSEvent addGlobalMonitorForEventsMatchingMask:NSLeftMouseUp | NSLeftMouseDown handler:^(NSEvent *event)
	{
		[self close];
	}];
	
	[NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:^(NSEvent *event) {
		[self handleKeyCode:event.keyCode flags:event.modifierFlags windowNumber:event.windowNumber];
		return event;
	}];
	
    return self;
}

- (void)open
{
	if( self.preferenceWindowController.window.isVisible )
	{
		NSLog( @"Preference window is visible." );
		return;
	}
	
	NSButton *button = [self.statusItem valueForKey:@"_button"];
	
	if( self.popover.isShown )
	{
		[self close];
		return;
	}
	
	button.state = NSOnState;
	
	[NSApp activateIgnoringOtherApps:YES];
	[self.popover showRelativeToRect:NSZeroRect ofView:button preferredEdge:NSMaxYEdge];
	[self.contentViewController updateHotKeyLabel];
	[self.contentViewController focusOnTextArea];
}

- (void)close
{
	NSButton *button = [self.statusItem valueForKey:@"_button"];
	button.state = NSOffState;
	
	[self.popover close];
}

- (void)handleKeyCode:(unsigned short)keyCode flags:(NSUInteger)flags windowNumber:(NSInteger)windowNumber
{
	NSWindow *window = [NSApp windowWithWindowNumber:windowNumber];
	if( [window.windowController isKindOfClass:[AllkdicWindowController class]] )
	{
		KeyBinding *keyBinding = [KeyBinding keyBindingWithKeyCode:keyCode flags:flags];
		[(AllkdicWindowController *)window.windowController handleKeyBinding:keyBinding];
	}
}

@end
