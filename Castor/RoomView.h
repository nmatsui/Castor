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
#import "Reloadable.h"
#import "EditView.h"
#import "SettingView.h"
#import "LongTextView.h"
#import "ImageView.h"
#import "ViewUtil.h"

@interface RoomView : UIViewController <UITableViewDataSource, UITableViewDelegate, Reloadable> {
    DataFactory *_factory;
    GroupData *_group;
    
    UITableView *_entryTable;
    NSMutableArray *_entryList;
    
    int _page;
    BOOL _portrate;
    
    int _tapCount;
    NSIndexPath *_selectedRow;
}

@property(nonatomic, retain) DataFactory *factory;
@property(nonatomic, retain) GroupData *group;

@property(nonatomic, retain) IBOutlet UITableView *entryTable;
@property(nonatomic, retain) IBOutlet NSMutableArray *entryList;

- (IBAction)callSetting:(id)sender;
- (IBAction)editEntry:(id)sender;

@end
