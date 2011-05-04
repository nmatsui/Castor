//
//  SettingView.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginView.h"
#import "DataFactory.h"

@interface SettingView : UIViewController {
    DataFactory *_factory;
}

@property(nonatomic, retain) DataFactory *factory;

- (IBAction)logoutClick:(id)sender;
@end
