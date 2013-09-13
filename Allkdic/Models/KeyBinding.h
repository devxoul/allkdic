//
//  KeyBinding.h
//  Allkdic
//
//  Created by 전수열 on 13. 9. 14..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyBinding : NSObject

@property (nonatomic, assign) NSInteger keyCode;
@property (nonatomic, assign) BOOL shift;
@property (nonatomic, assign) BOOL control;
@property (nonatomic, assign) BOOL option;
@property (nonatomic, assign) BOOL command;
@property (nonatomic, readonly) NSDictionary *dictionary;

+ (KeyBinding *)keyBindingWithKeyCode:(NSInteger)keyCode flags:(NSUInteger)flag;
+ (KeyBinding *)keyBindingWithDictionary:(NSDictionary *)dictionary;

+ (NSString *)keyStringFormKeyCode:(CGKeyCode)keyCode;
+ (CGKeyCode)keyCodeFormKeyString:(NSString *)keyString;

@end
