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

@interface RoomView : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, Reloadable> {
    DataFactory *_factory;
    RoomData *_room;
    
    UITableView *_entryTable;
    NSMutableArray *_entryList;
    
    int _page;
    BOOL _portrate;
    
    EntryData *_target;
    NSMutableArray *_selectors;
    
    UIActivityIndicatorView *_indicator;
}

@property(nonatomic, retain) DataFactory *factory;
@property(nonatomic, retain) RoomData *room;

@property(nonatomic, retain) IBOutlet UITableView *entryTable;
@property(nonatomic, retain) IBOutlet NSMutableArray *entryList;

@property(nonatomic, retain) EntryData *target;
@property(nonatomic, retain) NSMutableArray *selectors;

@property(nonatomic, retain) UIActivityIndicatorView *indicator;

- (IBAction)callSetting:(id)sender;
- (IBAction)editEntry:(id)sender;

@end
