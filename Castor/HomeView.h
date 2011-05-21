//
//  HomeView.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reloadable.h"
#import "Alertable.h"
#import "GroupView.h"
#import "DataFactory.h"
#import "CellBuilder.h"
#import "RoomData.h"
#import "EntryData.h"

@interface HomeView : UIViewController <UITableViewDataSource, UITableViewDelegate, Reloadable, Alertable> {
    UITableView *_homeTable;
    NSMutableArray *_homeList;
    DataFactory *_factory;
    CellBuilder *_cellBuilder;
    UIActivityIndicatorView *_indicator;
    
    BOOL _portrate;
}

@property(nonatomic, retain) IBOutlet UITableView *homeTable;
@property(nonatomic, retain) IBOutlet NSMutableArray *homeList;
@property(nonatomic, retain) DataFactory *factory;
@property(nonatomic, retain) CellBuilder *cellBuilder;
@property(nonatomic, retain) UIActivityIndicatorView *indicator;

- (IBAction)callSetting:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
              factory:(DataFactory *)factory;

@end
