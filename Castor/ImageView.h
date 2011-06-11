//
//  ImageView.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractView.h"
#import "EntryData.h"
#import "DataFactory.h"


@interface ImageView : AbstractView <UIScrollViewDelegate> {
    UIScrollView *_scrollView;
    UIImageView *_imageView;
    EntryData *_entry;
    UIActivityIndicatorView *_indicator;
}

@property(nonatomic, retain) IBOutlet UIImageView *imageView;
@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic, retain) EntryData *entry;
@property(nonatomic, retain) UIActivityIndicatorView *indicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
                entry:(EntryData *)entry 
              factory:(DataFactory *)factory;
@end
