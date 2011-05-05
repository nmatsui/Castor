//
//  CommentView.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataFactory.h"
#import "EditView.h"
#import "SettingView.h"
#import "ViewUtil.h"

@interface CommentView : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    DataFactory *factory;
    EntryData *originEntry;
    
    UITableView *entryTable;
    NSMutableArray *entryList;
    
    BOOL portrate;
}

@property(nonatomic, retain) DataFactory *factory;
@property(nonatomic, retain) EntryData *originEntry;

@property(nonatomic, retain) IBOutlet UITableView *entryTable;
@property(nonatomic, retain) IBOutlet NSMutableArray *entryList;

- (IBAction)callSetting:(id)sender;
- (IBAction)editEntry:(id)sender;
- (IBAction)reloadComment:(id)sender;

@end
