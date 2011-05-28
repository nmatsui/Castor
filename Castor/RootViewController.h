//
//  RootViewController.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
