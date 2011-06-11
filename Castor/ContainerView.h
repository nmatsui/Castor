//
//  ContainerView.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractView.h"
#import "DataFactory.h"
#import "HomeView.h"
#import "GroupView.h"
#import "Reloadable.h"

@class HomeView;
@class GroupView;

@interface ContainerView : AbstractView {
    UIToolbar *_toolbar;
    UIBarButtonItem *_toggleButton;
    DataFactory *_factory;
    HomeView *_homeView;
    GroupView *_groupView;
    UIViewController <Reloadable> *_currentView;
}

@property(nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *toggleButton;
@property(nonatomic, retain) DataFactory *factory;
@property(nonatomic, retain) HomeView *homeView;
@property(nonatomic, retain) GroupView *groupView;
@property(nonatomic, retain) UIViewController <Reloadable> *currentView;

- (IBAction)reload:(id)sender;
- (IBAction)callSetting:(id)sender;
- (IBAction)toggleView:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
              factory:(DataFactory *)factory;

@end
