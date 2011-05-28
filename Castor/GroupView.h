//
//  GroupView2.h
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
#import "RoomView.h"
#import "SettingView.h"
#import "CellBuilder.h"

@class ContainerView;

@interface GroupView : UIViewController <UITableViewDataSource, UITableViewDelegate, Reloadable, Alertable> {
    UITableView *_roomTable;
    NSMutableArray *_roomList;    
    DataFactory *_factory;
    UIActivityIndicatorView *_indicator;
    CellBuilder *_cellBuilder;
    UIView *_triggerHeader;
    UIView *_nilFooter;
    ContainerView *_container;
    BOOL _portrate;
    BOOL _headerON;
    UIToolbar *_toolbar;
}

@property(nonatomic, retain) IBOutlet UITableView *roomTable;
@property(nonatomic, retain) IBOutlet NSMutableArray *roomList;
@property(nonatomic, retain) DataFactory *factory;
@property(nonatomic, retain) UIActivityIndicatorView *indicator;
@property(nonatomic, retain) CellBuilder *cellBuilder;
@property(nonatomic, retain) UIView *triggerHeader;
@property(nonatomic, retain) UIView *nilFooter;
@property(nonatomic, assign) ContainerView *container;
@property(nonatomic, retain) IBOutlet UIToolbar *toolbar;

//- (IBAction)callSetting:(id)sender;
//- (IBAction)moveToHome:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
              factory:(DataFactory *)factory
            container:(ContainerView *)container;

@end
