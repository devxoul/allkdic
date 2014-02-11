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
#import "KeyBinding.h"
#import "AnalyticsHelper.h"

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
	
    AnalyticsHelper *ga = [AnalyticsHelper sharedInstance];
    [ga beginPeriodicReportingWithAccount:@"UA-42976442-2" name:@"올ㅋ사전" version:VERSION];
    
	[[SUUpdater sharedUpdater] checkForUpdatesInBackground];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    AnalyticsHelper *ga = [AnalyticsHelper sharedInstance];
    [ga handleApplicationWillTerminate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/**
 * Reference : http://dbachrach.com/blog/2005/11/program-global-hotkeys-in-cocoa-easily/
 */
EventHotKeyRef hotKeyRef;

- (void)registerHotKey
{
	EventHotKeyID hotKeyId;
	EventTypeSpec eventType;
	eventType.eventClass = kEventClassKeyboard;
	eventType.eventKind = kEventHotKeyPressed;
	
	// When hotkey event fired, hotKeyHandler is called.
	InstallApplicationEventHandler( &hotKeyHandler, 1, &eventType, NULL, NULL );
	
	// 4byte character
	hotKeyId.signature = 'allk';
	hotKeyId.id = 0;
	
	KeyBinding *keyBinding = [KeyBinding keyBindingWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:AllkdicSettingKeyHotKey]];
	if( !keyBinding ) {
		NSLog( @"No existing key setting." );
		keyBinding = [[KeyBinding alloc] init];
		keyBinding.option = YES;
		keyBinding.command = YES;
		keyBinding.keyCode = 49; // Space
		[[NSUserDefaults standardUserDefaults] setObject:keyBinding.dictionary forKey:AllkdicSettingKeyHotKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	
	NSLog( @"Bind HotKey : %@", keyBinding );
	
	UInt32 hotKeyModifiers = 0;
	if( keyBinding.shift ) {
		hotKeyModifiers += shiftKey;
	}
	if( keyBinding.option ) {
		hotKeyModifiers += optionKey;
	}
	if( keyBinding.control ) {
		hotKeyModifiers += controlKey;
	}
	if( keyBinding.command ) {
		hotKeyModifiers += cmdKey;
	}
	
	RegisterEventHotKey( (UInt32)keyBinding.keyCode, hotKeyModifiers, hotKeyId, GetApplicationEventTarget(), 0, &hotKeyRef );
	
	[self.allkdicController.contentViewController updateHotKeyLabel];
}

- (void)unregisterHotKey
{
	NSLog( @"Unbind HotKey" );
	UnregisterEventHotKey( hotKeyRef );
}


#pragma mark -
#pragma mark HotKey

OSStatus hotKeyHandler( EventHandlerCallRef nextHandler, EventRef theEvent, void *userData )
{
	[[(AppDelegate *)[NSApp delegate] allkdicController] open];
	
	return noErr;
}

@end

