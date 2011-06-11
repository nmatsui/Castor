//
//  LoginView.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
