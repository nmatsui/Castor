//
//  LongTextView.h
//  Castor
//
//  Copyright (C) 2011 Nobuyuki Matsui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractView.h"
#import "EntryData.h"

@interface LongTextView : AbstractView {
    UITextView *_textView;
    EntryData *_entry;
}

@property(nonatomic, retain) EntryData *entry;
@property(nonatomic, retain) IBOutlet UITextView *textView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
                entry:(EntryData *)entry
              factory:(DataFactory *)factory;
@end
