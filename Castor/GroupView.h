//
//  GroupView2.h
//  Castor
//
//  Copyright (C) 2011 Nobuyuki Matsui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractView.h"
#import "Reloadable.h"
#import "DataFactory.h"
#import "HomeView.h"
#import "RoomView.h"
#import "SettingView.h"
#import "CellBuilder.h"

@class ContainerView;

@interface GroupView : AbstractView <UITableViewDataSource, UITableViewDelegate, Reloadable> {
    UITableView *_roomTable;
    NSMutableArray *_roomList;    
    CellBuilder *_cellBuilder;
    UIView *_triggerHeader;
    UIView *_nilFooter;
    ContainerView *_container;
    BOOL _headerON;
    UIToolbar *_toolbar;
}

@property(nonatomic, retain) IBOutlet UITableView *roomTable;
@property(nonatomic, retain) IBOutlet NSMutableArray *roomList;
@property(nonatomic, retain) CellBuilder *cellBuilder;
@property(nonatomic, retain) UIView *triggerHeader;
@property(nonatomic, retain) UIView *nilFooter;
@property(nonatomic, assign) ContainerView *container;
@property(nonatomic, retain) IBOutlet UIToolbar *toolbar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
              factory:(DataFactory *)factory
            container:(ContainerView *)container;

@end
