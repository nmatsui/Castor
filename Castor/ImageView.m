//
//  ImageView.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageView.h"

@interface ImageView (Private)
- (void)_startIndicator:(id)sender;
- (void)_loadAttachmentImageInBackground:(id)arg;
@end

@implementation ImageView

@synthesize imageView = _imageView;
@synthesize scrollView = _scrollView;
@synthesize indicator = _indicator;
@synthesize entry = _entry;

static const float MAX_SCALE = 5.0;
static const float MIN_SCALE = 1.0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
                entry:(EntryData *)entry 
              factory:(DataFactory *)factory
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil factory:factory];
    if (self) {
        self.entry = entry;
        self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.view addSubview:self.indicator];
    }
    return self;
}

- (void)dealloc
{
    self.imageView = nil;
    self.scrollView = nil;
    self.indicator = nil;
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
    if (self.factory != nil) {
        self.scrollView.maximumZoomScale = MAX_SCALE;
        self.scrollView.minimumZoomScale = MIN_SCALE;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self performSelector:@selector(_startIndicator:) withObject:self];
        [self performSelectorInBackground:@selector(_loadAttachmentImageInBackground:) withObject:nil];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.imageView = nil;
    self.scrollView = nil;
    self.indicator = nil;
    self.entry = nil;
}

//// UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {  
    return self.imageView;  
} 

//// Private
- (void)_startIndicator:(id)sender
{
    CGRect viewSize = self.view.bounds;
    [self.indicator setFrame:CGRectMake(viewSize.size.width/2-25, viewSize.size.height/2-25, 50, 50)];
    [self.indicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)_loadAttachmentImageInBackground:(id)arg
{
    NSLog(@"load Attachment Image In Background");
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = [self.factory getAttachmentImageByEntryData:self.entry sender:self];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.indicator stopAnimating];
    [pool release];
}

@end
