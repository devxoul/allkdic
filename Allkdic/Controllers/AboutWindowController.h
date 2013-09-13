//
//  AboutWindowController.h
//  Allkdic
//
//  Created by 전수열 on 13. 8. 6..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AllkdicWindowController.h"

@interface AboutWindowController : AllkdicWindowController

@property (nonatomic, strong) IBOutlet NSTextField *versionLabel;

- (IBAction)checkForUpdate:(id)sender;
- (IBAction)viewOnGitHub:(id)sender;

@end
