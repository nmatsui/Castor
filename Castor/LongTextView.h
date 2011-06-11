//
//  LongTextView.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractView.h"
#import "EntryData.h"
#import "ContainerView.h"

@interface LongTextView : AbstractView {
    UITextView *_textView;
    EntryData *_entry;
    DataFactory *_factory;
}

@property(nonatomic, retain) EntryData *entry;
@property(nonatomic, retain) IBOutlet UITextView *textView;
@property(nonatomic, retain) DataFactory *factory;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
                entry:(EntryData *)entry
              factory:(DataFactory *)factory;
@end
