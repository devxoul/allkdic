//
//  AboutWindowController.m
//  Allkdic
//
//  Created by 전수열 on 13. 8. 6..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "AboutWindowController.h"
#import "AppDelegate.h"
#import <Sparkle/Sparkle.h>

@implementation AboutWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
	self.versionLabel.stringValue = [NSString stringWithFormat:@"버전 : %@ (빌드 %@)", VERSION, BUILD];
}

- (void)showWindow:(id)sender
{
	[[(AppDelegate *)[NSApp delegate] allkdicController] close];
	[super showWindow:sender];
}

- (IBAction)checkForUpdate:(id)sender
{
	[[SUUpdater sharedUpdater] checkForUpdates:self];
}

- (IBAction)viewOnGitHub:(id)sender
{
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/devxoul/allkdic"]];
}

@end
