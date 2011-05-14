//
//  LongTextView.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntryData.h"


@interface LongTextView : UIViewController {
    UITextView *_textView;
    EntryData *_entry;
    BOOL _portrate;
}

@property(nonatomic, retain) EntryData *entry;
@property(nonatomic, retain) IBOutlet UITextView *textView;

@end
