//
//  ContainerView.h
//  Castor
//
//  Copyright (C) 2011 Nobuyuki Matsui. All rights reserved.
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
    HomeView *_homeView;
    GroupView *_groupView;
    UIViewController <Reloadable> *_currentView;
}

@property(nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *toggleButton;
@property(nonatomic, retain) HomeView *homeView;
@property(nonatomic, retain) GroupView *groupView;
@property(nonatomic, retain) UIViewController <Reloadable> *currentView;

- (IBAction)reload:(id)sender;
- (IBAction)callSetting:(id)sender;
- (IBAction)toggleView:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
              factory:(DataFactory *)factory;

@end
