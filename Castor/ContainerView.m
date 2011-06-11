//
//  ContainerView.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContainerView.h"


@implementation ContainerView

@synthesize toolbar = _toolbar;
@synthesize toggleButton = _toggleButton;
@synthesize factory = _factory;
@synthesize homeView = _homeView;
@synthesize groupView = _groupView;
@synthesize currentView = _currentView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
              factory:(DataFactory *)factory
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.factory = factory;
        self.homeView = [[HomeView alloc] initWithNibName:@"HomeView" bundle:nil
                                                  factory:self.factory
                                                container:self];
        self.currentView = self.homeView;
        self.title = @"Home";
    }
    return self;
}

- (void)dealloc
{
    self.toolbar = nil;
    self.toggleButton = nil;
    self.factory = nil;
    self.homeView = nil;
    self.groupView = nil;
    self.currentView = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.factory == nil) {
        NSLog(@"DataFactory disappeared");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Homeへ移動します" 
                                                            message:@"メモリ不足のためキャッシュが破棄されました"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        ContainerView *containerView = [[[ContainerView alloc] initWithNibName:@"ContainerView" bundle:nil
                                                                       factory:[[DataFactory alloc] init]] autorelease];
        [self.navigationController pushViewController:containerView animated:YES];
    }
    NSLog(@"ContainerView Will appear");
    self.navigationController.navigationBar.hidden = NO;
    [self.currentView viewWillAppear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"ContainerView loaded");
    [self.navigationItem.backBarButtonItem setEnabled:NO];
    self.navigationItem.hidesBackButton = YES;
    [self.view insertSubview:self.homeView.view belowSubview:self.toolbar];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.toolbar = nil;
    self.toggleButton = nil;
    self.factory = nil;
    self.homeView = nil;
    self.groupView = nil;
    self.currentView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    [self.currentView shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    return YES;
}

//// IBAction
- (IBAction)reload:(id)sender
{
    NSLog(@"reload Container");
    [self.currentView performSelectorInBackground:@selector(reload:) withObject:self.currentView];
}
     
- (IBAction)callSetting:(id)sender
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"move to SettingView");
    SettingView *settingView = [[[SettingView alloc] initWithNibName:@"SettingView" bundle:nil 
                                                             factory:self.factory] autorelease];
    [self.navigationController pushViewController:settingView animated:YES];
    [pool release];
}

- (IBAction)toggleView:(id)sender
{
    if (self.groupView == nil) self.groupView = [[GroupView alloc] initWithNibName:@"GroupView" bundle:nil
                                                                           factory:self.factory 
                                                                         container:self];
    UIViewController *going = nil;
    UIViewController *comming = nil;
    UIViewAnimationOptions transition;
    NSString *title = @"";
    UIImage *buttonImage = nil;
    if ([self.homeView.view superview] != nil) {
        going = self.homeView;
        comming = self.groupView;
        transition = UIViewAnimationOptionTransitionFlipFromLeft;
        title = @"Group";
        buttonImage = [UIImage imageNamed:@"53-house.png"];
    }
    else {
        going = self.groupView;
        comming = self.homeView;
        transition = UIViewAnimationOptionTransitionFlipFromRight;
        title = @"Home";
        buttonImage = [UIImage imageNamed:@"44-shoebox.png"];
    }
    
    float w = [[UIScreen mainScreen] applicationFrame].size.width;
    float h = [[UIScreen mainScreen] applicationFrame].size.height;
    if (_portrate) {
        [comming.view setFrame:CGRectMake(0, 0, w, h)];
    }
    else {
        [comming.view setFrame:CGRectMake(0, 0, h, w)];
    }
    
    [UIView transitionWithView:self.view duration:0.75 options:transition animations:^{
        [comming viewWillAppear:YES];
        [going viewWillDisappear:YES];
        [going.view removeFromSuperview];
        [self.view insertSubview:comming.view belowSubview:self.toolbar];
        [going viewDidDisappear:YES];
        [comming viewDidAppear:YES];
        self.title = title;
        self.currentView = comming;
        [self.toggleButton setImage:buttonImage];
        [self.currentView performSelectorInBackground:@selector(reload:) withObject:self.currentView];
    } completion:NULL];
}
@end
