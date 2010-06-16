// Copyright (C) 2008 Dirk Holtwick <dirk.holtwick@gmail.com>. All rights reserved.

#import <UIKit/UIKit.h>
#import "EditViewController.h"
#import "CustomCell.h"

@interface RootViewController : UITableViewController {
    NSMutableArray *data;
    EditViewController *editViewController;    
    NSString *pathToUserCopyOfPlist;    
    IBOutlet CustomCell *tableCell;
}

@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) EditViewController *editViewController;
@property (nonatomic, copy) NSString *pathToUserCopyOfPlist;

@end
