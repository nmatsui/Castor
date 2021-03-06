//
//  ImageView.m
//  Castor
//
//  Copyright (C) 2011 Nobuyuki Matsui. All rights reserved.
//

#import "ImageView.h"

@interface ImageView (Private)
- (void)_loadAttachmentImageInBackground:(id)arg;
@end

@implementation ImageView

@synthesize imageView = _imageView;
@synthesize scrollView = _scrollView;
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
    }
    return self;
}

- (void)dealloc
{
    self.imageView = nil;
    self.scrollView = nil;
    self.entry = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"ImageView Will appear");
    if (self.factory != nil) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self performSelector:@selector(_startIndicator:) withObject:self];
        [self performSelectorInBackground:@selector(_loadAttachmentImageInBackground:) withObject:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"ImageView loaded");
    self.title = @"Image";
    self.scrollView.maximumZoomScale = MAX_SCALE;
    self.scrollView.minimumZoomScale = MIN_SCALE;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.imageView = nil;
    self.scrollView = nil;
    self.entry = nil;
}

//// UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {  
    return self.imageView;  
} 

//// Private
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
