//
//  PocketDictionary.h
//  PocketDictionary
//
//  Created by 전수열 on 13. 8. 5..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "PocketDictionaryContentView.h"

@interface PocketDictionary : NSObject

@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) NSWindow *window;
@property (nonatomic, strong) NSPopover *popover;
@property (nonatomic, strong) PocketDictionaryContentView *contentView;

- (id)initWithStatusItem:(NSStatusItem *)statusItem;
- (void)show;

@end
