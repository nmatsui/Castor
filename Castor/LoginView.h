//
//  LoginView.h
//  Castor
//
//  Copyright (C) 2011 Nobuyuki Matsui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractView.h"
#import "DataFactory.h"
#import "ContainerView.h"


@interface LoginView : AbstractView {
    UITextField *_email;
    UITextField *_password;
    UIButton    *_loginButton;
}

@property(nonatomic, retain) IBOutlet UITextField *email;
@property(nonatomic, retain) IBOutlet UITextField *password;
@property(nonatomic, retain) IBOutlet UIButton    *loginButton;

- (IBAction)loginClick:(id)sender;
- (IBAction)doneEmailEdit:(id)sender;
- (IBAction)donePasswordEdit:(id)sender;
- (IBAction)backTap:(id)sender;

@end
