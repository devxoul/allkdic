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
#import "AnalyticsHelper.h"

@implementation AboutWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
	self.versionLabel.stringValue = [NSString stringWithFormat:@"버전 : %@ (빌드 %@)", VERSION, BUILD];
}

- (void)showWindow:(id)sender
{
	[[(AppDelegate *)[NSApp delegate] allkdicController] close];
	self.window.level = NSScreenSaverWindowLevel;
	[super showWindow:sender];
    
    [[AnalyticsHelper sharedInstance] recordScreenWithName:@"AboutWindow"];
}

- (IBAction)checkForUpdate:(id)sender
{
    [[AnalyticsHelper sharedInstance] recordCachedEventWithCategory:AKAnalyticsCategoryAbout
                                                             action:AKAnalyticsActionCheckForUpdate
                                                             label:nil value:nil];
	[[SUUpdater sharedUpdater] checkForUpdates:self];
}

- (IBAction)viewOnGitHub:(id)sender
{
    [[AnalyticsHelper sharedInstance] recordCachedEventWithCategory:AKAnalyticsCategoryAbout
                                                             action:AKAnalyticsActionViewOnGitHub label:nil value:nil];
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/devxoul/allkdic"]];
}

- (IBAction)quit:(id)sender
{
	[NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

@end
