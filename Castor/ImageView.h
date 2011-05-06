//
//  ImageView.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntryData.h"
#import "DataFactory.h"


@interface ImageView : UIViewController {
    DataFactory *_factory;
    EntryData *_entry;
    
    UIImageView *_imageView;
    
    BOOL _portrate;
}

@property(nonatomic, retain) DataFactory *factory;
@property(nonatomic, retain) EntryData *entry;
@property(nonatomic, retain) IBOutlet UIImageView *imageView;

@end
