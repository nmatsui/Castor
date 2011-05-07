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
@synthesize parentId = _parentId;
@synthesize targetEntry = _targetEntry;
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
    if (self.targetEntry == nil) {
        NSLog(@"add entry (parentId[%@])", self.parentId);
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        [self.factory addEntryText:self.textView.text roomId:self.roomId parentId:self.parentId sender:self];
        [self.previousView reload:nil];
        [self.navigationController popViewControllerAnimated:YES];
        [pool release];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setDelegate:self];
        [alert setTitle:@"Can't execution"];
        [alert setMessage:@"更新APIがまだ提供されていません"];
        [alert addButtonWithTitle:@"OK"];
        [alert show];
        [alert release];
    }
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
    self.parentId = nil;
    self.targetEntry = nil;
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
    if (self.targetEntry == nil) {
        self.title = @"Add Entry";
    }
    else {
        self.title = @"Update Entry";
        self.textView.text = self.targetEntry.content;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.factory = nil;
    self.parentId = nil;
    self.targetEntry = nil;
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
