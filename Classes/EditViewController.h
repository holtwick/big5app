// Copyright (C) 2008 Dirk Holtwick <dirk.holtwick@gmail.com>. All rights reserved.

#import <UIKit/UIKit.h>

@interface EditViewController : UIViewController <UITextFieldDelegate> {

    NSMutableArray *data;
    NSString *pathToUserCopyOfPlist;
    NSInteger row;
    
    IBOutlet UITextField *fieldTitle;
    IBOutlet UITextField *fieldUrl;
    
}

@property (nonatomic, retain) UITextField *fieldTitle;
@property (nonatomic, retain) UITextField *fieldUrl;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, copy) NSString *pathToUserCopyOfPlist;

- (void)editRow:(NSInteger)newRow;

@end
