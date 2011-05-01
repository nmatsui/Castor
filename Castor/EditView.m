//
//  EditView.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EditView.h"


@implementation EditView

@synthesize factory;
@synthesize originEntry;

@synthesize textView;

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
    [self.navigationController popViewControllerAnimated:YES];
    [pool release];
}

- (IBAction)doneEntryEdit:(id)sender
{
    NSLog(@"done Entry editing");
    [textView resignFirstResponder];
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
    
    self.textView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
