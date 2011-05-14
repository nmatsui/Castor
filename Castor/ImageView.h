//
//  ImageView.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Alertable.h"
#import "EntryData.h"
#import "DataFactory.h"


@interface ImageView : UIViewController <Alertable> {
    UIImageView *_imageView;
    DataFactory *_factory;
    EntryData *_entry;
    BOOL _portrate;
}

@property(nonatomic, retain) DataFactory *factory;
@property(nonatomic, retain) EntryData *entry;
@property(nonatomic, retain) IBOutlet UIImageView *imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
                entry:(EntryData *)entry 
              factory:(DataFactory *)factory;
@end
