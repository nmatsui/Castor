//
//  SettingView.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingView.h"

@implementation SettingView

@synthesize factory = _factory;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
              factory:(DataFactory *)factory
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.factory = factory;
    }
    return self;
}

- (void)dealloc
{
    self.factory = nil;
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"SettingView loaded");
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.factory = nil;
}

//// IBAction
- (IBAction)logoutClick:(id)sender
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [self.factory clearAuthToken];
    NSLog(@"move to LoginView");
    LoginView *loginView = [[[LoginView alloc] initWithNibName:@"LoginView" bundle:nil
                                                       factory:self.factory] autorelease];
    [self.navigationController pushViewController:loginView animated:YES];
    [pool release];
}

- (IBAction)cacheDeleteClick:(id)sender
{
    NSLog(@"cache Delete");
    [self.factory deleteCache];
}

@end
