//
//  RootViewController.h
//  Castor
//
//  Copyright (C) 2011 Nobuyuki Matsui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataFactory.h"
#import "LoginView.h"
#import "ContainerView.h"
#import "HomeView.h"

@interface RootViewController : UIViewController {
    DataFactory *_factory;
}

@property(nonatomic, retain) DataFactory *factory;

@end
