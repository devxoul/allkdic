//
//  AboutWindowController.m
//  Allkdic
//
//  Created by 전수열 on 13. 8. 6..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "AboutWindowController.h"
#import "AppDelegate.h"

@implementation AboutWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (void)showWindow:(id)sender
{
	[[(AppDelegate *)[NSApp delegate] allkdicController] close];
	[super showWindow:sender];
}

- (IBAction)checkForUpdate:(id)sender
{
	
}

- (IBAction)viewOnGitHub:(id)sender
{
	[NSApp openURL:[NSURL URLWithString:@"https://github.com/devxoul/allkdic"]];
}

@end
