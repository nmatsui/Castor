//
//  RootViewController.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

@synthesize factory = _factory;

- (void)checkAuthorizedInBackground:(id)arg
{
    NSLog(@"checkAuthorized In Background");
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [NSThread sleepForTimeInterval:1];
    self.factory = [[DataFactory alloc] init];
    if ([self.factory hasAuthToken]) {
        NSLog(@"move to GroupView");
        GroupView *groupView = [[[GroupView alloc] initWithNibName:@"GroupView" bundle:nil] autorelease];
        groupView.factory = self.factory;
        [self.navigationController pushViewController:groupView animated:YES];
    }
    else {
        NSLog(@"move to LoginView");
        LoginView *loginView = [[[LoginView alloc] initWithNibName:@"LoginView" bundle:nil] autorelease];
        loginView.factory = self.factory;
        [self.navigationController pushViewController:loginView animated:YES];
    }
    [pool release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"RootView Loaded");
    self.navigationController.navigationBar.hidden = YES;
    [self performSelectorInBackground:@selector(checkAuthorizedInBackground:) withObject:Nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.factory = nil;
}

- (void)dealloc
{
    self.factory = nil;
    
    [super dealloc];
}

@end
