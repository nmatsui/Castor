//
//  GroupView.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataFactory.h"
#import "GroupCell.h"


@interface GroupView : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    DataFactory *factory;
    
    UITableView *groupTable;
    NSMutableArray *groupList;
    GroupCell *groupCell;
}

@property(nonatomic, retain) DataFactory *factory;

@property(nonatomic, retain) IBOutlet UITableView *groupTable;
@property(nonatomic, retain) IBOutlet NSMutableArray *groupList;
@property(nonatomic, retain) IBOutlet GroupCell *groupCell;

-(IBAction) reloadGroup:(id)sender;

@end
