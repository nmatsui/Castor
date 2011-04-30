//
//  RoomView.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataFactory.h"



@interface RoomView : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    DataFactory *factory;
    NSNumber *roomId;
    
    UITableView *entryTable;
    NSMutableArray *entryList;
    
    BOOL portrate;
}

@property(nonatomic, retain) DataFactory *factory;
@property(nonatomic, retain) NSNumber *roomId;

@property(nonatomic, retain) IBOutlet UITableView *entryTable;
@property(nonatomic, retain) IBOutlet NSMutableArray *entryList;

- (IBAction)reloadRoom:(id)sender;

@end
