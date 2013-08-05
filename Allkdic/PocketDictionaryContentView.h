//
//  PocketDictionaryContentView.h
//  PocketDictionary
//
//  Created by 전수열 on 13. 8. 5..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface PocketDictionaryContentView : NSView

@property (nonatomic, strong) WebView *webView;

- (void)focusOnTextArea;

@end
