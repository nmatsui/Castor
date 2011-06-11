//
//  AbstractView.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
