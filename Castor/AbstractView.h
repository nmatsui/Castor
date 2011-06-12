//
//  AbstractView.h
//  Castor
//
//  Copyright (C) 2011 Nobuyuki Matsui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataFactory.h"

@class DataFactory;

@interface AbstractView : UIViewController {
    DataFactory *_factory;
    BOOL _portrate;
    UIActivityIndicatorView *_indicator;
}

@property(nonatomic, retain) DataFactory *factory;
@property(nonatomic, retain) UIActivityIndicatorView *indicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
              factory:(DataFactory *)factory;
- (id)initWithNibNameNoIndicator:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
                         factory:(DataFactory *)factory;
- (void)alertException:(NSString *)message;

@end
