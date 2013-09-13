//
//  AppDelegate.h
//  Allkdic
//
//  Created by 전수열 on 13. 8. 4..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AllkdicController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) AllkdicController *allkdicController;
@property (nonatomic, strong) NSStatusItem *statusItem;

- (void)registerHotKey;
- (void)unregisterHotKey;

@end
