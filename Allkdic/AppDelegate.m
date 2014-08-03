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
    [self terminateAlreadyRunning];
    
	self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	
	NSImage *icon = [NSImage imageNamed:@"statusicon_default"];
	icon.template = YES;
	self.statusItem.image = icon;
	
	self.allkdicController = [[AllkdicController alloc] initWithStatusItem:self.statusItem];
	
	self.statusItem.target = self.allkdicController;
	self.statusItem.action = @selector(open);
	
	NSButton *button = [self.statusItem valueForKey:@"_button"];
	button.focusRingType = NSFocusRingTypeNone;
	[button setButtonType:NSPushOnPushOffButton];
	
    [self moveToApplicationFolderIfNeeded];
    
	[self registerHotKey];
    
	if( ![LoginUtil willStartAtLogin] ) {
		[LoginUtil setStartAtLoginEnabled:YES];
	}
	
    AnalyticsHelper *ga = [AnalyticsHelper sharedInstance];
    [ga beginPeriodicReportingWithAccount:@"UA-42976442-2" name:@"올ㅋ사전" version:VERSION];
    
	[[SUUpdater sharedUpdater] checkForUpdatesInBackground];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [[AnalyticsHelper sharedInstance] handleApplicationWillTerminate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)terminateAlreadyRunning
{
    int pid = [[NSProcessInfo processInfo] processIdentifier];
    NSString *filter = @"Contents/MacOS/Allkdic";
    NSString *cmd = [NSString stringWithFormat:
                     @"ps aux | grep '%@' | awk '{if($2 != %d) print $2}' | xargs kill -9", filter, pid];
    NSTask *task = [NSTask launchedTaskWithLaunchPath:@"/bin/sh" arguments:@[@"-c", cmd]];
    [task waitUntilExit];
}

- (void)moveToApplicationFolderIfNeeded
{
    BOOL ignore = [[[NSUserDefaults standardUserDefaults] objectForKey:AKIgnoreApplicationFolderWarning] boolValue];
    if (ignore) {
        return;
    }
    
    if( [self isInApplicationFolder] ) {
        return;
    }
    
    NSString *message = @"자동 업데이트 등의 기능이 원활하게 이루어지지 않을 수 있습니다.\n지금 이동하시겠습니까?";
    NSAlert *alert = [NSAlert alertWithMessageText:@"올ㅋ사전이 애플리케이션 폴더에 있지 않습니다."
                                     defaultButton:@"이동"
                                   alternateButton:@"다시 묻지 않음"
                                       otherButton:@"취소"
                         informativeTextWithFormat:@"%@", message];
    NSModalResponse response = [alert runModal];
    switch( response ) {
        // 다시 묻지 않음
        case 0:
            [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:AKIgnoreApplicationFolderWarning];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
            
        // 취소
        case -1:
            break;
            
        // 이동
        case 1:
            [self moveToApplicationFolder];
            break;
    }
}

- (BOOL)isInApplicationFolder
{
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSAllDomainsMask, YES);
    for( NSString *path in paths ) {
        if( [bundlePath hasPrefix:path] ) {
            return YES;
        }
    }
    return NO;
}

- (void)moveToApplicationFolder
{
    NSString *sourcePath = [[NSBundle mainBundle] bundlePath];
    NSString *bundleName = sourcePath.lastPathComponent;
    NSArray *applicationPaths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSLocalDomainMask, YES);
    NSString *destPath = [applicationPaths.lastObject stringByAppendingPathComponent:bundleName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existing = [fileManager fileExistsAtPath:destPath];
    if( existing ) {
        // Terminate running process at destination path.
        NSString *cmd = [NSString stringWithFormat:@"ps aux | grep '%@' | awk '{print $2}' | xargs kill -9", destPath];
        NSTask *task = [NSTask launchedTaskWithLaunchPath:@"/bin/sh" arguments:@[@"-c", cmd]];
        [task waitUntilExit];
        
        // Move existing app to trash
        BOOL success = [[NSWorkspace sharedWorkspace] performFileOperation:NSWorkspaceRecycleOperation
                                                                    source:[destPath stringByDeletingLastPathComponent]
                                                               destination:nil files:@[bundleName] tag:nil];
        if( !success ) {
            NSLog(@"Failed to trash existing app.");
        }
    }
    
    // Copy to `/Application` folder.
    NSError *error = nil;
    [fileManager copyItemAtPath:sourcePath toPath:destPath error:&error];
    if( error ) {
        NSLog(@"Error copying file: %@", error);
    }
    
    // Remove downloaded app to trash
    [fileManager removeItemAtPath:sourcePath error:&error];
    if( error ) {
        NSLog(@"Removing downloaded file: %@", error);
    }
    
    // Run new app
    NSString *cmd = [NSString stringWithFormat:@"open %@", destPath];
    NSTask *task = [NSTask launchedTaskWithLaunchPath:@"/bin/sh" arguments:@[@"-c", cmd]];
    [task waitUntilExit];
    
    [NSApp terminate:nil];
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

