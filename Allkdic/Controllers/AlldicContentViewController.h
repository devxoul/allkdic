//
//  AlldicContentViewController.h
//  Allkdic
//
//  Created by 전수열 on 13. 8. 6..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "AboutWindowController.h"

@interface AlldicContentViewController : NSViewController

@property (nonatomic, strong) IBOutlet WebView *webView;
@property (nonatomic, strong) AboutWindowController *aboutWindowController;

- (void)focusOnTextArea;
- (IBAction)showAboutWindow:(id)sender;

@end
