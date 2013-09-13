//
//  AppDelegate.m
//  Allkdic
//
//  Created by 전수열 on 13. 8. 4..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "AppDelegate.h"
#import <Carbon/Carbon.h>
#import <Sparkle/Sparkle.h>
#import "LoginUtil.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	
	NSImage *icon = [NSImage imageNamed:@"statusicon_default.png"];
	icon.template = YES;
	self.statusItem.image = icon;
	
	self.allkdicController = [[AllkdicController alloc] initWithStatusItem:self.statusItem];
	
	self.statusItem.target = self.allkdicController;
	self.statusItem.action = @selector(open);
	
	NSButton *button = [self.statusItem valueForKey:@"_button"];
	button.focusRingType = NSFocusRingTypeNone;
	[button setButtonType:NSPushOnPushOffButton];
	
	[self registerHotKey];
	
	if( ![LoginUtil willStartAtLogin] )
	{
		[LoginUtil setStartAtLoginEnabled:YES];
	}
	
	[[SUUpdater sharedUpdater] checkForUpdatesInBackground];
}


/**
 * Reference : http://dbachrach.com/blog/2005/11/program-global-hotkeys-in-cocoa-easily/
 */
- (void)registerHotKey
{
	EventHotKeyRef hotKeyRef;
	EventHotKeyID hotKeyId;
	EventTypeSpec eventType;
	eventType.eventClass = kEventClassKeyboard;
	eventType.eventKind = kEventHotKeyPressed;
	
	// When hotkey event fired, hotKeyHandler is called.
	InstallApplicationEventHandler( &hotKeyHandler, 1, &eventType, NULL, NULL );
	
	// 4byte character
	hotKeyId.signature = 'xoul';
	hotKeyId.id = 0;
	
	// Register hotkey. (option + command + space)
	RegisterEventHotKey( 49, optionKey + cmdKey, hotKeyId, GetApplicationEventTarget(), 0, &hotKeyRef );
}


#pragma mark -
#pragma mark HotKey

OSStatus hotKeyHandler( EventHandlerCallRef nextHandler, EventRef theEvent, void *userData )
{
	[[(AppDelegate *)[NSApp delegate] allkdicController] open];
	
	return noErr;
}

@end

