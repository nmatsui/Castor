//
//  EditView.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractView.h"
#import "Reloadable.h"
#import "DataFactory.h"
#import "EntryData.h"


@interface EditView : AbstractView <UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    UITextView *_textView;
    UILabel *_letterCount;
    UIButton *_cameraButton;
    UIImageView *_clipIcon;
    UIButton *_postButton;
    NSNumber *_roomId;
    NSNumber *_parentId;
    EntryData *_targetEntry;
    UIImagePickerController *_cameraController;
    UIImage *_attachmentImage;
    UIViewController <Reloadable> *_previousView;
    UIActivityIndicatorView *_indicator;
}

@property(nonatomic, retain) IBOutlet UITextView *textView;
@property(nonatomic, retain) IBOutlet UILabel *letterCount;
@property(nonatomic, retain) IBOutlet UIButton *cameraButton;
@property(nonatomic, retain) IBOutlet UIImageView *clipIcon;
@property(nonatomic, retain) IBOutlet UIButton *postButton;
@property(nonatomic, retain) NSNumber *roomId;
@property(nonatomic, retain) NSNumber *parentId;
@property(nonatomic, retain) EntryData *targetEntry;
@property(nonatomic, retain) UIImagePickerController *cameraController;
@property(nonatomic, retain) UIImage *attachmentImage;
@property(nonatomic, retain) UIViewController <Reloadable> *previousView;
@property(nonatomic, retain) UIActivityIndicatorView *indicator;

- (IBAction)postEntry:(id)sender;
- (IBAction)openCameraView:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
               roomId:(NSNumber *)roomId 
             parentId:(NSNumber *)parentId 
          targetEntry:(EntryData *)targetEntry 
         previousView:(UIViewController <Reloadable> *)previousView 
              factory:(DataFactory *)factory;

@end
