//
//  AppDelegate.h
//  PocketDictionary
//
//  Created by 전수열 on 13. 8. 4..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PocketDictionary.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) PocketDictionary *pocketDictionary;
@property (nonatomic, strong) NSStatusItem *statusItem;

- (void)show;

@end
