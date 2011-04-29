//
//  GroupView.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GroupView : UIViewController {
    IBOutlet UITableView *groupTable;
}
-(IBAction) reloadGroup:(id)sender;

@end
