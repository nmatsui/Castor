//
//  EditView.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reloadable.h"
#import "DataFactory.h"
#import "EntryData.h"


@interface EditView : UIViewController {
    DataFactory *_factory;
    NSNumber *_roomId;
    EntryData *_originEntry;
    UIViewController <Reloadable> *_previousView;
    
    UITextView *_textView;
    
    BOOL _portrate;
}

@property(nonatomic, retain) DataFactory *factory;
@property(nonatomic, retain) NSNumber *roomId;
@property(nonatomic, retain) EntryData *originEntry;
@property(nonatomic, retain) UIViewController <Reloadable> *previousView;
@property(nonatomic, retain) IBOutlet UITextView *textView;

- (IBAction)postEntry:(id)sender;
- (IBAction)doneEntryEdit:(id)sender;
@end
