//
//  PreferenceWindowController.m
//  Allkdic
//
//  Created by 전수열 on 13. 9. 14..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "AKHotKeyManager.h"
#import "PreferenceWindowController.h"
#import "AlldicContentViewController.h"
#import "AllkdicController.h"
#import "AnalyticsHelper.h"

@implementation PreferenceWindowController

- (void)windowDidLoad
{
	[super windowDidLoad];
	
	KeyBinding *keyBinding = [KeyBinding keyBindingWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:AllkdicSettingKeyHotKey]];
	[self handleKeyBinding:keyBinding];
}

- (void)showWindow:(id)sender
{
    [AKHotKeyManager unregisterHotKey];
	
	self.window.level = NSScreenSaverWindowLevel;
	
	[super showWindow:sender];
    
    [[AnalyticsHelper sharedInstance] recordScreenWithName:@"PreferenceWindow"];
}

- (BOOL)windowShouldClose:(id)sender
{
	[AKHotKeyManager registerHotKey];
	return YES;
}

- (void)controlTextDidChange:(NSNotification *)obj
{
	NSTextField *textField = (NSTextField *)obj.object;
	if( textField == self.hotKeyTextField )
	{
		textField.stringValue = @"";
	}
}

- (void)handleKeyBinding:(KeyBinding *)keyBinding
{
	if( !keyBinding.shift && !keyBinding.control && !keyBinding.option && !keyBinding.command ) {
		return;
	}
    
    if( [self.keyBinding isEqual:keyBinding] ) {
        return;
    }
    self.keyBinding = keyBinding;
	
	NSLog( @"New HotKey : %@", keyBinding );
	
	self.shiftLabel.textColor = self.controlLabel.textColor = self.altLabel.textColor = self.commandLabel.textColor = [NSColor lightGrayColor];
	
	if( keyBinding.shift ) {
		self.shiftLabel.textColor = [NSColor blackColor];
	}
	if( keyBinding.control ) {
		self.controlLabel.textColor = [NSColor blackColor];
	}
	if( keyBinding.option ) {
		self.altLabel.textColor = [NSColor blackColor];
	}
	if( keyBinding.command ) {
		self.commandLabel.textColor = [NSColor blackColor];
	}
	
	self.keyLabel.stringValue = [KeyBinding keyStringFormKeyCode:keyBinding.keyCode].capitalizedString;
	
	[[NSUserDefaults standardUserDefaults] setObject:keyBinding.dictionary forKey:AllkdicSettingKeyHotKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	[[AllkdicController sharedController].contentViewController updateHotKeyLabel];
    
    [[AnalyticsHelper sharedInstance] recordCachedEventWithCategory:AKAnalyticsCategoryPreference
                                                             action:AKAnalyticsActionUpdateHotKey label:nil value:nil];
}

@end
