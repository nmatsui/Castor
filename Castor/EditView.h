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


@interface EditView : UIViewController <UITextViewDelegate> {
    DataFactory *_factory;
    NSNumber *_roomId;
    NSNumber *_parentId;
    EntryData *_targetEntry;
    UIViewController <Reloadable> *_previousView;
    
    UITextView *_textView;
    UILabel *_letterCount;
    
    BOOL _portrate;
}

@property(nonatomic, retain) DataFactory *factory;
@property(nonatomic, retain) NSNumber *roomId;
@property(nonatomic, retain) NSNumber *parentId;
@property(nonatomic, retain) EntryData *targetEntry;
@property(nonatomic, retain) UIViewController <Reloadable> *previousView;
@property(nonatomic, retain) IBOutlet UITextView *textView;
@property(nonatomic, retain) IBOutlet UILabel *letterCount;

- (IBAction)postEntry:(id)sender;
- (IBAction)doneEntryEdit:(id)sender;
@end
