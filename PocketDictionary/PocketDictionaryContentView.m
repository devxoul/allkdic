//
//  PocketDictionaryContentView.m
//  PocketDictionary
//
//  Created by 전수열 on 13. 8. 5..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "PocketDictionaryContentView.h"

@implementation PocketDictionaryContentView

- (id)init
{
	self = [super initWithFrame:NSMakeRect( 0, 0, 405, 514 )];
	
	self.webView = [[WebView alloc] initWithFrame:self.frame];
	self.webView.mainFrameURL = @"http://endic.naver.com/popManager.nhn?m=miniPopMain";
	[self addSubview:self.webView];
	
	[self.webView becomeFirstResponder];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webviewDidFinishLoading) name:WebViewProgressFinishedNotification object:nil];
	
	return self;
}

- (void)webviewDidFinishLoading
{
	[self focusOnTextArea];
}

- (void)focusOnTextArea
{
	[self.webView.mainFrameDocument evaluateWebScript:@"document.ac_input.focus()"];
}

@end
