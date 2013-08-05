//
//  AllkdicController.h
//  Allkdic
//
//  Created by 전수열 on 13. 8. 5..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "AllkdicContentView.h"

@interface AllkdicController : NSObject <NSWindowDelegate>

@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) NSPopover *popover;
@property (nonatomic, strong) AllkdicContentView *contentView;

- (id)initWithStatusItem:(NSStatusItem *)statusItem;
- (void)open;
- (void)close;

@end
