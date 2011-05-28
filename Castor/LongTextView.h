//
//  LongTextView.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntryData.h"
#import "ContainerView.h"

@interface LongTextView : UIViewController {
    UITextView *_textView;
    EntryData *_entry;
    DataFactory *_factory;
    BOOL _portrate;
}

@property(nonatomic, retain) EntryData *entry;
@property(nonatomic, retain) IBOutlet UITextView *textView;
@property(nonatomic, retain) DataFactory *factory;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
                entry:(EntryData *)entry
              factory:(DataFactory *)factory;
@end
