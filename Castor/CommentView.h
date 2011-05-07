//
//  CommentView.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataFactory.h"
#import "Reloadable.h"
#import "EditView.h"
#import "SettingView.h"
#import "ViewUtil.h"

@interface CommentView : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, Reloadable> {
    DataFactory *_factory;
    RoomData *_room;
    EntryData *_originEntry;
    
    UITableView *_entryTable;
    NSMutableArray *_entryList;
    
    BOOL _portrate;
    
    EntryData *_target;
    EntryData *_willDelete;
    NSMutableArray *_selectors;
    
    UIViewController <Reloadable> *_previousView;
    
    UIActivityIndicatorView *_indicator;
}

@property(nonatomic, retain) DataFactory *factory;
@property(nonatomic, retain) RoomData *room;
@property(nonatomic, retain) EntryData *originEntry;

@property(nonatomic, retain) IBOutlet UITableView *entryTable;
@property(nonatomic, retain) IBOutlet NSMutableArray *entryList;

@property(nonatomic, retain) EntryData *target;
@property(nonatomic, retain) EntryData *willDelete;
@property(nonatomic, retain) NSMutableArray *selectors;

@property(nonatomic, retain) UIViewController <Reloadable> *previousView;

@property(nonatomic, retain) UIActivityIndicatorView *indicator;

- (IBAction)callSetting:(id)sender;
- (IBAction)addEntry:(id)sender;

@end
