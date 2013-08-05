//
//  AllkdicContentView.m
//  Allkdic
//
//  Created by 전수열 on 13. 8. 5..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "AllkdicContentView.h"

@implementation AllkdicContentView

- (id)init
{
	self = [super initWithFrame:NSMakeRect( 0, 0, 405, 513+38 )];
	
	self.webView = [[WebView alloc] initWithFrame:NSMakeRect( 0, 0, 405, 513 )];
	self.webView.mainFrameURL = @"http://endic.naver.com/popManager.nhn?m=miniPopMain";
	[self addSubview:self.webView];
	
	NSImageView *line = [[NSImageView alloc] initWithFrame:NSMakeRect( 0, self.frame.size.height - 38, 405, 2 )];
	line.image = [NSImage imageNamed:@"line.png"];
	[self addSubview:line];
	
	NSTextField *titleLabel = [[NSTextField alloc] init];
	titleLabel.stringValue = BUNDLE_NAME;
	[titleLabel setAlignment:NSCenterTextAlignment];
	[titleLabel setEnabled:NO];
	[titleLabel setEditable:NO];
	[titleLabel setBordered:NO];
	[titleLabel setBackgroundColor:[NSColor clearColor]];
	[titleLabel sizeToFit];
	titleLabel.frame = NSMakeRect( 0, self.frame.size.height - titleLabel.frame.size.height - 9, 405, titleLabel.frame.size.height );
	[self addSubview:titleLabel];
	
	NSButton *helpButton = [[NSButton alloc] initWithFrame:NSMakeRect( 375, self.frame.size.height - 31, 25, 25 )];
	helpButton.title = nil;
	helpButton.bezelStyle = NSHelpButtonBezelStyle;
	[self addSubview:helpButton];
	
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
