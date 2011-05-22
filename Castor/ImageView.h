//
//  ImageView.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Alertable.h"
#import "HomeView.h"
#import "EntryData.h"
#import "DataFactory.h"


@interface ImageView : UIViewController <UIScrollViewDelegate, Alertable> {
    UIScrollView *_scrollView;
    UIImageView *_imageView;
    DataFactory *_factory;
    EntryData *_entry;
    UIActivityIndicatorView *_indicator;
    BOOL _portrate;
}

@property(nonatomic, retain) IBOutlet UIImageView *imageView;
@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic, retain) DataFactory *factory;
@property(nonatomic, retain) EntryData *entry;
@property(nonatomic, retain) UIActivityIndicatorView *indicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
                entry:(EntryData *)entry 
              factory:(DataFactory *)factory;
@end
