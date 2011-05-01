//
//  EditView.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataFactory.h"
#import "EntryData.h"


@interface EditView : UIViewController {
    DataFactory *factory;
    EntryData *originEntry;
    
    UITextView *textView;
}

@property(nonatomic, retain) DataFactory *factory;
@property(nonatomic, retain) EntryData *originEntry;
@property(nonatomic, retain) IBOutlet UITextView *textView;

- (IBAction)postEntry:(id)sender;
- (IBAction)doneEntryEdit:(id)sender;
@end
