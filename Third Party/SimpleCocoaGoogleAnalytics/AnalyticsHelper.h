//
//  AnalyticsHelper.h
//
//  Created by Stephen Lind on 9/26/13.
//

#import <Foundation/Foundation.h>

/*
 SWL Sept 2013
 
 AnalyticsHelper is a simple, singleton interface for recording and sending events to your google analytics account.
 
 This class is *not* thread safe. All calls to it should be performed from the main thread. Reports are sent on a background thread. If the send fails, an error event will be sent the next time analytics are reported.
 */

@interface AnalyticsHelper : NSObject

// create/access the shared instance
+ (AnalyticsHelper*)sharedInstance;

// Calculates how long the app has been open and stores the in-memory data for later reports.
// This should be called when applicationWillTerminate, and should be accompanied by a
// [NSUserDefaults.standardUserDefaults synchronize];
- (void)handleApplicationWillTerminate;

// Track a screen. These are cached until the next report interval
- (void)recordScreenWithName:(NSString*)screenName;

// Record an event. These are cached until the next report interval
- (void)recordCachedEventWithCategory:(NSString*)eventCategory
                                 action:(NSString*)eventAction
                                  label:(NSString*)eventLabel
                                  value:(NSNumber*)eventValue;

// begin reporting with
- (void)beginPeriodicReportingWithAccount:(NSString*)googleAccountIdentifier
                                     name:(NSString*)appName
                                  version:(NSString*)appVersion;
@end