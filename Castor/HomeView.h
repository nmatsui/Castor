//
//  HomeView.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractView.h"
#import "Reloadable.h"
#import "ContainerView.h"
#import "GroupView.h"
#import "RoomView.h"
#import "CommentView.h"
#import "SettingView.h"
#import "DataFactory.h"
#import "CellBuilder.h"
#import "RoomData.h"
#import "EntryData.h"

@class ContainerView;

@interface HomeView : AbstractView <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate, Reloadable> {
    UITableView *_homeTable;
    NSMutableArray *_homeList;
    DataFactory *_factory;
    CellBuilder *_cellBuilder;
    RoomData *_targetRoom;
    EntryData *_targetEntry;
    NSMutableArray *_selectors;
    UIActivityIndicatorView *_indicator;
    UIView *_triggerHeader;
    UIView *_triggerFooter;
    ContainerView *_container;
    int _page;
    BOOL _headerON;
    BOOL _footerON;
}

@property(nonatomic, retain) IBOutlet UITableView *homeTable;
@property(nonatomic, retain) IBOutlet NSMutableArray *homeList;
@property(nonatomic, retain) DataFactory *factory;
@property(nonatomic, retain) CellBuilder *cellBuilder;
@property(nonatomic, retain) RoomData *targetRoom;
@property(nonatomic, retain) EntryData *targetEntry;
@property(nonatomic, retain) NSMutableArray *selectors;
@property(nonatomic, retain) UIActivityIndicatorView *indicator;
@property(nonatomic, retain) UIView *triggerHeader;
@property(nonatomic, retain) UIView *triggerFooter;
@property(nonatomic, assign) ContainerView *container;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
              factory:(DataFactory *)factory
            container:(ContainerView *)container;

@end
