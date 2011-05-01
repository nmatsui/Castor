//
//  LoginView.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginView.h"


@implementation LoginView

@synthesize factory;

@synthesize email;
@synthesize password;
@synthesize loginButton;

- (IBAction)loginClick:(id)sender
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSLog(@"%s:%s",[email.text UTF8String], [password.text UTF8String]);
    NSLog(@"move to GroupView");
    GroupView *groupView = [[[GroupView alloc] initWithNibName:@"GroupView" bundle:nil] autorelease];
    groupView.factory = self.factory;
    [self.navigationController pushViewController:groupView animated:YES];
    [pool release];
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
    [email resignFirstResponder];
    [password resignFirstResponder];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

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
    self.title = @"Login";
    if (self.factory == nil) {
        self.factory = [[DataFactory alloc] init];
    }
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
