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
#import "RoomView.h"
#import "SettingView.h"
#import "ViewUtil.h"


@interface GroupView : UIViewController <UITableViewDataSource, UITableViewDelegate, Reloadable, Alertable> {
    UITableView *_roomTable;
    NSMutableArray *_roomList;    
    DataFactory *_factory;
    UIActivityIndicatorView *_indicator;
    BOOL _portrate;
}

@property(nonatomic, retain) IBOutlet UITableView *roomTable;
@property(nonatomic, retain) IBOutlet NSMutableArray *roomList;
@property(nonatomic, retain) DataFactory *factory;
@property(nonatomic, retain) UIActivityIndicatorView *indicator;

- (IBAction)callSetting:(id)sender;

@end
