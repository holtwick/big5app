//
//  CustomCell.h
//  Big5WebApp
//
//  Created by Dirk on 23.04.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomCell : UITableViewCell {

    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *urlLabel;
        
}

@property (nonatomic,retain) IBOutlet UILabel *titleLabel;
@property (nonatomic,retain) IBOutlet UILabel *urlLabel;

@end
