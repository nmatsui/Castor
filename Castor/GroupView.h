//
//  GroupView2.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataFactory.h"
#import "RoomView.h"
#import "SettingView.h"
#import "ViewUtil.h"


@interface GroupView : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    DataFactory *_factory;
    
    UITableView *_roomTable;
    NSMutableArray *_roomList;
    
    BOOL _portrate;
    
    UIActivityIndicatorView *_indicator;
}

@property(nonatomic, retain) DataFactory *factory;

@property(nonatomic, retain) IBOutlet UITableView *roomTable;
@property(nonatomic, retain) IBOutlet NSMutableArray *roomList;

@property(nonatomic, retain) UIActivityIndicatorView *indicator;

- (IBAction)callSetting:(id)sender;

@end
