//
//  AppDelegate.h
//  PocketDictionary
//
//  Created by 전수열 on 13. 8. 4..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PocketDictionaryController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) PocketDictionaryController *pocketDictionaryController;
@property (nonatomic, strong) NSStatusItem *statusItem;

@end
