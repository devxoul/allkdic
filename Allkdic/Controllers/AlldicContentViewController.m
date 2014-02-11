//
//  AlldicContentViewController.m
//  Allkdic
//
//  Created by 전수열 on 13. 8. 6..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "AlldicContentViewController.h"
#import "AllkdicController.h"
#import "AnalyticsHelper.h"

@implementation AlldicContentViewController

- (void)awakeFromNib
{
	self.webView.mainFrameURL = @"http://endic.naver.com/popManager.nhn?m=miniPopMain";
	[self.indicator startAnimation:nil];
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

- (void)webView:(WebView *)sender willPerformClientRedirectToURL:(NSURL *)URL delay:(NSTimeInterval)seconds
       fireDate:(NSDate *)date forFrame:(WebFrame *)frame
{
    NSString *urlString = URL.absoluteString;
    if( [urlString rangeOfString:@"query="].location != NSNotFound )
    {
        NSString *dicType = nil;
        if( [urlString hasPrefix:@"http://endic"] ) {
            dicType = AKAnalyticsValueEnglish;
        }
        else if( [urlString hasPrefix:@"http://krdic"] ) {
            dicType = AKAnalyticsValueKorean;
        }
        else if( [urlString hasPrefix:@"http://hanja"] ) {
            dicType = AKAnalyticsValueHanja;
        }
        else if( [urlString hasPrefix:@"http://jpdic"] ) {
            dicType = AKAnalyticsValueJapanese;
        }
        else if( [urlString hasPrefix:@"http://cndic"] ) {
            dicType = AKAnalyticsValueChinese;
        }
        else if( [urlString hasPrefix:@"http://frdic"] ) {
            dicType = AKAnalyticsValueFrench;
        }
        
        [[AnalyticsHelper sharedInstance] recordCachedEventWithCategory:AKAnalyticsCategoryAllkdic
                                                                 action:AKAnalyticsActionSearch
                                                                  label:dicType
                                                                  value:nil];
    }
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
	[self.indicator stopAnimation:nil];
	[self focusOnTextArea];
}

- (void)focusOnTextArea
{
	[self javascript:@"ac_input.focus()"];
	[self javascript:@"ac_input.select()"];
}

- (void)handleKeyBinding:(KeyBinding *)keyBinding
{
	// Esc
	if( !keyBinding.shift && !keyBinding.control && !keyBinding.option && !keyBinding.command && keyBinding.keyCode == 53 )
	{
		[[AllkdicController sharedController] close];
	}
	
	// Command + A
	else if( !keyBinding.shift && !keyBinding.control && !keyBinding.option && keyBinding.command && keyBinding.keyCode == [KeyBinding keyCodeFormKeyString:@"a"] )
	{
		[self focusOnTextArea];
	}
	
	// Command + X
	else if( !keyBinding.shift && !keyBinding.control && !keyBinding.option && keyBinding.command && keyBinding.keyCode == [KeyBinding keyCodeFormKeyString:@"x"] )
	{
		NSString *input = [self javascript:@"ac_input.value.slice(ac_input.selectionStart, ac_input.selectionEnd)"];
		[[NSPasteboard generalPasteboard] clearContents];
		[[NSPasteboard generalPasteboard] setString:input forType:NSStringPboardType];
		NSLog( @"'%@' has been copied.", input );
		
		NSMutableString *script = [NSMutableString string];
		[script appendString:@"var selection = ac_input.selectionStart;"];
		[script appendString:@"ac_input.value = ac_input.value.substring(0, ac_input.selectionStart) + ac_input.value.substr(ac_input.selectionEnd,  ac_input.value.length - ac_input.selectionEnd);"];
		[script appendString:@"ac_input.selectionStart = ac_input.selectionEnd = selection;"];
		[self javascript:script];
	}
	
	// Command + C
	else if( !keyBinding.shift && !keyBinding.control && !keyBinding.option && keyBinding.command && keyBinding.keyCode == [KeyBinding keyCodeFormKeyString:@"c"] )
	{
		NSString *input = [self javascript:@"ac_input.value.slice(ac_input.selectionStart, ac_input.selectionEnd)"];
		[[NSPasteboard generalPasteboard] clearContents];
		[[NSPasteboard generalPasteboard] setString:input forType:NSStringPboardType];
		NSLog( @"'%@' has been copied.", input );
	}
	
	// Command + V
	else if( !keyBinding.shift && !keyBinding.control && !keyBinding.option && keyBinding.command && keyBinding.keyCode == [KeyBinding keyCodeFormKeyString:@"v"] )
	{
		NSString *input = [[NSPasteboard generalPasteboard] stringForType:NSStringPboardType];
		if( !input ) return;
		
		NSMutableString *script = [NSMutableString string];
		[script appendFormat:@"var input = '%@';", input];
		[script appendString:@"var selection = ac_input.selectionStart + input.length;"];
		[script appendString:@"ac_input.value = ac_input.value.substring(0, ac_input.selectionStart) + input + ac_input.value.substr(ac_input.selectionEnd,  ac_input.value.length - ac_input.selectionEnd);"];
		[script appendString:@"ac_input.selectionStart = ac_input.selectionEnd = selection;"];
		[self javascript:script];
	}
}

- (id)javascript:(NSString *)javascript
{
	return [self.webView.mainFrameDocument evaluateWebScript:javascript];
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
