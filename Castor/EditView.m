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
@synthesize letterCount = _letterCount;

static const int MAX_LETTER = 140;

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
    if ([self.textView.text length] > MAX_LETTER) {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setDelegate:self];
        [alert setMessage:@"140文字を越えています"];
        [alert addButtonWithTitle:@"OK"];
        [alert show];
        [alert release];
        return;
    }
    if (self.targetEntry == nil) {
        NSLog(@"add entry (parentId[%@])", self.parentId);
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        [self.factory addEntryText:self.textView.text roomId:self.roomId parentId:self.parentId sender:self];
        [self.previousView reload:nil];
        [self.navigationController popViewControllerAnimated:YES];
        [pool release];
    }
    else {
        NSLog(@"edit entry (entryId[%@])", self.targetEntry.entryId);
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        [self.factory updateEntryText:self.textView.text roomId:self.roomId entryId:self.targetEntry.entryId sender:self];
        [self.previousView reload:nil];
        [self.navigationController popViewControllerAnimated:YES];
        [pool release];
    }
}

- (IBAction)doneEntryEdit:(id)sender
{
    NSLog(@"done Entry editing");
    [self.textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    int textcount = MAX_LETTER - ([textView.text length] + [text length] - range.length);
    if (textcount < 0) {
        self.letterCount.textColor=[UIColor redColor];
    }else{
        self.letterCount.textColor=[UIColor blackColor];
    }
    self.letterCount.text = [NSString stringWithFormat:@"%d", textcount];
    return YES;
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
        self.letterCount.text = [NSString stringWithFormat:@"%d", MAX_LETTER];
    }
    else {
        self.title = @"Update Entry";
        self.textView.text = self.targetEntry.content;
        self.letterCount.text = [NSString stringWithFormat:@"%d", MAX_LETTER - [self.targetEntry.content length]];
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
