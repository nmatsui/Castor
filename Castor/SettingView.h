//
//  SettingView.h
//  Castor
//
//  Copyright (C) 2011 Nobuyuki Matsui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractView.h"
#import "LoginView.h"
#import "DataFactory.h"
#import "CacheManager.h"

@interface SettingView : AbstractView {
}

- (IBAction)logoutClick:(id)sender;
- (IBAction)cacheDeleteClick:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
              factory:(DataFactory *)factory;
@end
