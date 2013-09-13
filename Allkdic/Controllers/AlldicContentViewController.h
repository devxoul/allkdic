//
//  AlldicContentViewController.h
//  Allkdic
//
//  Created by 전수열 on 13. 8. 6..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "PreferenceWindowController.h"
#import "AboutWindowController.h"
#import "KeyBinding.h"

@interface AlldicContentViewController : NSViewController

@property (nonatomic, strong) IBOutlet NSTextField *hotKeyLabel;
@property (nonatomic, strong) IBOutlet WebView *webView;
@property (nonatomic, strong) IBOutlet NSButton *menuButton;
@property (nonatomic, strong) IBOutlet NSMenu *menu;

- (void)updateHotKeyLabel;
- (void)focusOnTextArea;
- (void)handleKeyBinding:(KeyBinding *)keyBinding;
- (IBAction)showMenu:(id)sender;
- (IBAction)showPreferenceWindow:(id)sender;
- (IBAction)showAboutWindow:(id)sender;
- (IBAction)quit:(id)sender;

@end
