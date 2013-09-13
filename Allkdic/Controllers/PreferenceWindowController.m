//
//  PreferenceWindowController.m
//  Allkdic
//
//  Created by 전수열 on 13. 9. 14..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "PreferenceWindowController.h"
#import "AppDelegate.h"

@implementation PreferenceWindowController

- (void)windowDidLoad
{
	[super windowDidLoad];
}

- (void)showWindow:(id)sender
{
	[[(AppDelegate *)[NSApp delegate] allkdicController] close];
	[super showWindow:sender];
}

- (void)keyDown:(NSEvent *)theEvent
{
	NSLog( @"keydown : %@", theEvent );
}

- (void)controlTextDidChange:(NSNotification *)obj
{
	NSTextField *textField = (NSTextField *)obj.object;
	
	textField.stringValue = @"";
}

@end
