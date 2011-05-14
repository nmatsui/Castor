//
//  ImageView.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageView.h"

@interface ImageView (Private)
- (void)_loadAttachmentImageInBackground:(id)arg;
@end

@implementation ImageView

@synthesize imageView = _imageView;
@synthesize scrollView = _scrollView;
@synthesize factory = _factory;
@synthesize entry = _entry;

static const float MAX_SCALE = 5.0;
static const float MIN_SCALE = 1.0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
                entry:(EntryData *)entry 
              factory:(DataFactory *)factory
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.entry = entry;
        self.factory = factory;
    }
    return self;
}

- (void)dealloc
{
    self.imageView = nil;
    self.scrollView = nil;
    self.factory = nil;
    self.entry = nil;
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
    NSLog(@"ImageView loaded");
    self.title = @"Image";
    self.scrollView.maximumZoomScale = MAX_SCALE;
    self.scrollView.minimumZoomScale = MIN_SCALE;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self performSelectorInBackground:@selector(_loadAttachmentImageInBackground:) withObject:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.imageView = nil;
    self.scrollView = nil;
    self.factory = nil;
    self.entry = nil;
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

//// UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {  
    return self.imageView;  
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

//// Private
- (void)_loadAttachmentImageInBackground:(id)arg
{
    NSLog(@"load Attachment Image In Background");
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = [self.factory getAttachmentImageByEntryData:self.entry sender:self];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [pool release];
}

@end
