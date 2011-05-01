//
//  RoomView.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataFactory.h"
#import "CommentView.h"
#import "EditView.h"
#import "LongTextView.h"
#import "ImageView.h"
#import "ViewUtil.h"

@interface RoomView : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    DataFactory *factory;
    GroupData *group;
    
    UITableView *entryTable;
    NSMutableArray *entryList;
    
    BOOL portrate;
    
    int tapCount;
    NSIndexPath *selectedRow;
}

@property(nonatomic, retain) DataFactory *factory;
@property(nonatomic, retain) GroupData *group;

@property(nonatomic, retain) IBOutlet UITableView *entryTable;
@property(nonatomic, retain) IBOutlet NSMutableArray *entryList;

- (IBAction)reloadRoom:(id)sender;
- (IBAction)editEntry:(id)sender;

@end
