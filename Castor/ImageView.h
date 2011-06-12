//
//  ImageView.h
//  Castor
//
//  Copyright (C) 2011 Nobuyuki Matsui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractView.h"
#import "EntryData.h"
#import "DataFactory.h"


@interface ImageView : AbstractView <UIScrollViewDelegate> {
    UIScrollView *_scrollView;
    UIImageView *_imageView;
    EntryData *_entry;
}

@property(nonatomic, retain) IBOutlet UIImageView *imageView;
@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic, retain) EntryData *entry;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
                entry:(EntryData *)entry 
              factory:(DataFactory *)factory;
@end
