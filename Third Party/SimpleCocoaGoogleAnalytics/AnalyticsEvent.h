//
//  AnalyticsEvent.h
//  DraftControl
//
//  Created by Stephen Lind on 9/30/13.
//  Copyright (c) 2013 Stephen Lind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalyticsEvent : NSObject

@property (strong) NSString *category;
@property (strong) NSString *action;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSNumber *value;

+ (AnalyticsEvent*)analyticsEventWithDictionary:(NSDictionary*)dict;
- (NSDictionary*)dictionaryRepresenation;

@end
