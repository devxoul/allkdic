//
//  AlldicContentViewController.h
//  Allkdic
//
//  Created by 전수열 on 13. 8. 6..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface AlldicContentViewController : NSViewController

@property (nonatomic, strong) IBOutlet WebView *webView;

- (void)focusOnTextArea;
- (IBAction)showAboutWindow:(id)sender;

@end
