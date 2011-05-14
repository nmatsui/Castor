//
//  LoginView.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginView.h"

@interface LoginView (Private)
- (void)_authenticateInBackground:(id)arg;
@end

@implementation LoginView

@synthesize email = _email;
@synthesize password = _password;
@synthesize loginButton = _loginButton;
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
    self.email = nil;
    self.password = nil;
    self.loginButton = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"LoginView Will appear");
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"LoginView loaded");
    self.title = @"Login";
    [self.navigationItem.backBarButtonItem setEnabled:NO];
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.factory = nil;
    self.email = nil;
    self.password = nil;
    self.loginButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

//// Alertable
- (void)alertException:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setDelegate:self];
    [alert setMessage:message];
    [alert addButtonWithTitle:@"OK"];
	[alert show];
	[alert release];
}

/// IBAction
- (IBAction)loginClick:(id)sender
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSLog(@"%@:%@",self.email.text, self.password.text);
    [self performSelectorInBackground:@selector(_authenticateInBackground:) withObject:Nil];
}
- (IBAction)doneEmailEdit:(id)sender
{
    [sender resignFirstResponder];
}
- (IBAction)donePasswordEdit:(id)sender
{
    [sender resignFirstResponder];
}
- (IBAction)backTap:(id)sender
{
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
}

//// Private
- (void)_authenticateInBackground:(id)arg
{
    NSLog(@"authenticate In Background");
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    BOOL result = [self.factory storeAuthTokenWithEmail:self.email.text password:self.password.text sender:self];
    if (result) {
        NSLog(@"move to GroupView");
        GroupView *groupView = [[[GroupView alloc] initWithNibName:@"GroupView" bundle:nil 
                                                           factory:self.factory] autorelease];
        [self.navigationController pushViewController:groupView animated:YES];
    }
    [pool release];
}

@end
