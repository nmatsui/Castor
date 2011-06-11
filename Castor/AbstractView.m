//
//  AbstractView.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AbstractView.h"


@implementation AbstractView

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

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.factory == nil) {
        NSLog(@"DataFactory disappeared");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Homeに戻ります" 
                                                            message:@"メモリ不足のためキャッシュが破棄されました"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.factory = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        _portrate = NO;
    }
    else if (interfaceOrientation == UIDeviceOrientationPortraitUpsideDown || interfaceOrientation == UIDeviceOrientationPortrait) {
        _portrate = YES;
    }
    return YES;
}

- (void)alertException:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setDelegate:self];
    [alert setMessage:message];
    [alert addButtonWithTitle:@"OK"];
	[alert show];
	[alert release];
}

@end
