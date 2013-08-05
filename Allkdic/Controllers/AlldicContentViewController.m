//
//  AlldicContentViewController.m
//  Allkdic
//
//  Created by 전수열 on 13. 8. 6..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "AlldicContentViewController.h"
#import "AboutWindowController.h"

@implementation AlldicContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

- (IBAction)showAboutWindow:(id)sender
{
	AboutWindowController *aboutWindowController = [[AboutWindowController alloc] initWithWindowNibName:@"AboutWindow"];
	[aboutWindowController showWindow:self];
}

@end
