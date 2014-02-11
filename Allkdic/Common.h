//
//  Common.h
//  Allkdic
//
//  Created by 전수열 on 13. 8. 6..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#define VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define BUILD [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define BUNDLE_NAME [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];

static NSString *AllkdicSettingKeyHotKey = @"AllkdicSettingKeyHotKey";

static NSString *AKAnalyticsCategoryAllkdic = @"Allkdic";
static NSString *AKAnalyticsCategoryPreference = @"Preference";

static NSString *AKAnalyticsActionOpen = @"Open";
static NSString *AKAnalyticsActionClose = @"Close";
static NSString *AKAnalyticsActionSearch = @"Search";
static NSString *AKAnalyticsActionUpdateHotKey = @"UpdateHotKey";

static NSString *AKAnalyticsValueEnglish = @"English";
static NSString *AKAnalyticsValueKorean = @"Korean";
static NSString *AKAnalyticsValueHanja = @"Hanja";
static NSString *AKAnalyticsValueJapanese = @"Japanese";
static NSString *AKAnalyticsValueChinese = @"Chinese";
static NSString *AKAnalyticsValueFrench = @"French";