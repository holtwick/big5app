// Copyright (C) 2008 Dirk Holtwick <dirk.holtwick@gmail.com>. All rights reserved.

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface Big5WebAppAppDelegate : NSObject <UIApplicationDelegate> {    
    UIWindow *window;
    UINavigationController *navigationController;
    RootViewController *rootViewController;
    NSMutableArray *data;
    NSString *pathToUserCopyOfPlist;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, copy) NSString *pathToUserCopyOfPlist;

@end

