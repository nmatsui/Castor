//
//  EditView.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EditView.h"


@implementation EditView

@synthesize factory = _factory;
@synthesize roomId = _roomId;
@synthesize originEntry = _originEntry;
@synthesize previousView = _previousView;

@synthesize textView = _textView;

- (void)alertException:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setDelegate:self];
    [alert setMessage:message];
    [alert addButtonWithTitle:@"OK"];
	[alert show];
	[alert release];
}

- (IBAction)postEntry:(id)sender
{
    NSLog(@"post entry");
    if (self.originEntry != nil) {
        NSLog(@"parent entryId [%d]", [self.originEntry.entryId intValue]);
    }
    else {
        NSLog(@"no parent");
    }
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *str = self.textView.text;
    NSLog(@"%@", str);
    [self.factory sendEntryText:self.textView.text roomId:self.roomId parentId:(self.originEntry != nil) ? self.originEntry.entryId : nil sender:self];
    
    [self.previousView reload:nil];
    [self.navigationController popViewControllerAnimated:YES];
    [pool release];
}

- (IBAction)doneEntryEdit:(id)sender
{
    NSLog(@"done Entry editing");
    [self.textView resignFirstResponder];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.factory = nil;
    self.originEntry = nil;
    self.previousView = nil;
    
    self.textView = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"EditView loaded");
    self.title = @"Edit";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.factory = nil;
    self.originEntry = nil;
    self.previousView = nil;
    
    self.textView = nil;
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

@end
