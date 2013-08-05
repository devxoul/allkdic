//
//  LoginUtil.h
//  Allkdic
//
//  Created by 전수열 on 13. 8. 6..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginUtil : NSObject

@property BOOL startAtLogin;

+ (BOOL)willStartAtLogin;
+ (void)setStartAtLoginEnabled:(BOOL)enabled;

@end
