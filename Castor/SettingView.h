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
#import "ContainerView.h"
#import "CacheManager.h"

@interface SettingView : UIViewController {
    DataFactory *_factory;
}

@property(nonatomic, retain) DataFactory *factory;

- (IBAction)logoutClick:(id)sender;
- (IBAction)cacheDeleteClick:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
              factory:(DataFactory *)factory;
@end
