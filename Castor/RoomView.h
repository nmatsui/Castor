//
//  RoomView.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reloadable.h"
#import "Alertable.h"
#import "DataFactory.h"
#import "ContainerView.h"
#import "HomeView.h"
#import "CommentView.h"
#import "EditView.h"
#import "SettingView.h"
#import "LongTextView.h"
#import "ImageView.h"
#import "CellBuilder.h"

@interface RoomView : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate, Reloadable, Alertable> {
    UITableView *_entryTable;
    NSMutableArray *_entryList;
    DataFactory *_factory;
    RoomData *_room;
    EntryData *_target;
    EntryData *_willDelete;
    NSMutableArray *_selectors;
    UIActivityIndicatorView *_indicator;
    CellBuilder *_cellBuilder;
    UIView *_triggerHeader;
    UIView *_triggerFooter;
    int _page;
    BOOL _portrate;
    BOOL _headerON;
    BOOL _footerON;
}

@property(nonatomic, retain) IBOutlet UITableView *entryTable;
@property(nonatomic, retain) IBOutlet NSMutableArray *entryList;
@property(nonatomic, retain) DataFactory *factory;
@property(nonatomic, retain) RoomData *room;
@property(nonatomic, retain) EntryData *target;
@property(nonatomic, retain) EntryData *willDelete;
@property(nonatomic, retain) NSMutableArray *selectors;
@property(nonatomic, retain) UIActivityIndicatorView *indicator;
@property(nonatomic, retain) CellBuilder *cellBuilder;
@property(nonatomic, retain) UIView *triggerHeader;
@property(nonatomic, retain) UIView *triggerFooter;

- (IBAction)callSetting:(id)sender;
- (IBAction)addEntry:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
                 room:(RoomData *)room 
              factory:(DataFactory *)factory;

@end
