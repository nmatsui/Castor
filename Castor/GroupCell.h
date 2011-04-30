//
//  GroupCell.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GroupCell : UITableViewCell {
    UILabel *groupName;
}

@property(nonatomic, retain) IBOutlet UILabel *groupName;

@end
