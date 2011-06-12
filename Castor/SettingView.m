//
//  SettingView.m
//  Castor
//
//  Copyright (C) 2011 Nobuyuki Matsui. All rights reserved.
//

#import "SettingView.h"

@implementation SettingView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
              factory:(DataFactory *)factory
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil factory:factory];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
