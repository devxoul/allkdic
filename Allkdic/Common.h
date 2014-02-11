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

static NSString * const AKIgnoreApplicationFolderWarning = @"AKIgnoreApplicationFolder";
static NSString * const AllkdicSettingKeyHotKey = @"AllkdicSettingKeyHotKey";

static NSString * const AKAnalyticsCategoryAllkdic = @"Allkdic";
static NSString * const AKAnalyticsCategoryPreference = @"Preference";

static NSString * const AKAnalyticsActionOpen = @"Open";
static NSString * const AKAnalyticsActionClose = @"Close";
static NSString * const AKAnalyticsActionSearch = @"Search";
static NSString * const AKAnalyticsActionUpdateHotKey = @"UpdateHotKey";

static NSString * const AKAnalyticsValueEnglish = @"English";
static NSString * const AKAnalyticsValueKorean = @"Korean";
static NSString * const AKAnalyticsValueHanja = @"Hanja";
static NSString * const AKAnalyticsValueJapanese = @"Japanese";
static NSString * const AKAnalyticsValueChinese = @"Chinese";
static NSString * const AKAnalyticsValueFrench = @"French";