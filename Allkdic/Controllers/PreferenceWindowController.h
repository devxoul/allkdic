//
//  PreferenceWindowController.h
//  Allkdic
//
//  Created by 전수열 on 13. 9. 14..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AllkdicWindowController.h"

@interface PreferenceWindowController : AllkdicWindowController <NSWindowDelegate>

@property (nonatomic, strong) KeyBinding *keyBinding;

@property (nonatomic, strong) IBOutlet NSTextField *hotKeyTextField;
@property (nonatomic, strong) IBOutlet NSTextField *shiftLabel;
@property (nonatomic, strong) IBOutlet NSTextField *controlLabel;
@property (nonatomic, strong) IBOutlet NSTextField *altLabel;
@property (nonatomic, strong) IBOutlet NSTextField *commandLabel;
@property (nonatomic, strong) IBOutlet NSTextField *keyLabel;

@end
