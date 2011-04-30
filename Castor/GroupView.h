//
//  GroupView2.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataFactory.h"
#import "RoomView.h"
#import "ViewUtil.h"

@interface GroupView : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    DataFactory *factory;
    
    UITableView *groupTable;
    NSMutableArray *groupList;
    
    BOOL portrate;
}

@property(nonatomic, retain) DataFactory *factory;

@property(nonatomic, retain) IBOutlet UITableView *groupTable;
@property(nonatomic, retain) IBOutlet NSMutableArray *groupList;

@end
