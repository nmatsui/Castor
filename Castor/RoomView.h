//
//  RoomView.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractView.h"
#import "Reloadable.h"
#import "DataFactory.h"
#import "CommentView.h"
#import "EditView.h"
#import "SettingView.h"
#import "LongTextView.h"
#import "ImageView.h"
#import "CellBuilder.h"

@interface RoomView : AbstractView <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate, Reloadable> {
    UITableView *_entryTable;
    NSMutableArray *_entryList;
    RoomData *_room;
    EntryData *_target;
    EntryData *_willDelete;
    NSMutableArray *_selectors;
    CellBuilder *_cellBuilder;
    UIView *_triggerHeader;
    UIView *_triggerFooter;
    int _page;
    BOOL _headerON;
    BOOL _footerON;
}

@property(nonatomic, retain) IBOutlet UITableView *entryTable;
@property(nonatomic, retain) IBOutlet NSMutableArray *entryList;
@property(nonatomic, retain) RoomData *room;
@property(nonatomic, retain) EntryData *target;
@property(nonatomic, retain) EntryData *willDelete;
@property(nonatomic, retain) NSMutableArray *selectors;
@property(nonatomic, retain) CellBuilder *cellBuilder;
@property(nonatomic, retain) UIView *triggerHeader;
@property(nonatomic, retain) UIView *triggerFooter;

- (IBAction)callSetting:(id)sender;
- (IBAction)addEntry:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
                 room:(RoomData *)room 
              factory:(DataFactory *)factory;

@end
