//
//  AlldicContentViewController.m
//  Allkdic
//
//  Created by 전수열 on 13. 8. 6..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "AlldicContentViewController.h"
#import "AllkdicController.h"

@implementation AlldicContentViewController

- (void)awakeFromNib
{
	self.webView.mainFrameURL = @"http://endic.naver.com/popManager.nhn?m=miniPopMain";
}

- (void)updateHotKeyLabel
{
	KeyBinding *keyBinding = [KeyBinding keyBindingWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:AllkdicSettingKeyHotKey]];
	NSMutableArray *keys = [NSMutableArray array];
	if( keyBinding.shift ) {
		[keys addObject:@"Shift"];
	}
	if( keyBinding.option ) {
		[keys addObject:@"Option"];
	}
	if( keyBinding.control ) {
		[keys addObject:@"Control"];
	}
	if( keyBinding.command ) {
		[keys addObject:@"Command"];
	}
	[keys addObject:[[KeyBinding keyStringFormKeyCode:keyBinding.keyCode] capitalizedString]];
	self.hotKeyLabel.stringValue = [keys componentsJoinedByString:@" + "];
}

- (void)webviewDidFinishLoading
{
	[self focusOnTextArea];
}

- (void)focusOnTextArea
{
	[self.webView.mainFrameDocument evaluateWebScript:@"document.ac_input.focus()"];
}

- (IBAction)showMenu:(id)sender
{
	[self.menu popUpMenuPositioningItem:[self.menu itemAtIndex:0] atLocation:self.menuButton.frame.origin inView:self.view];
}

- (IBAction)showPreferenceWindow:(id)sender
{
	[[AllkdicController sharedController].preferenceWindowController showWindow:self];
}

- (IBAction)showAboutWindow:(id)sender
{
	[[AllkdicController sharedController].aboutWindowController showWindow:self];
}

- (IBAction)quit:(id)sender
{
	[NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

@end
