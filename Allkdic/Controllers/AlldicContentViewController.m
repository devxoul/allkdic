//
//  AlldicContentViewController.m
//  Allkdic
//
//  Created by 전수열 on 13. 8. 6..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "AlldicContentViewController.h"

@implementation AlldicContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	self.preferenceWindowController = [[PreferenceWindowController alloc] initWithWindowNibName:@"PreferenceWindow"];
	self.aboutWindowController = [[AboutWindowController alloc] initWithWindowNibName:@"AboutWindow"];
	
	return self;
}

- (void)awakeFromNib
{
	self.webView.mainFrameURL = @"http://endic.naver.com/popManager.nhn?m=miniPopMain";
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
	[self.preferenceWindowController showWindow:self];
}

- (IBAction)showAboutWindow:(id)sender
{
	[self.aboutWindowController showWindow:self];	
}

- (IBAction)quit:(id)sender
{
	[NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

@end
