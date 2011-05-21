//
//  LoginView.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Alertable.h"
#import "DataFactory.h"
#import "HomeView.h"


@interface LoginView : UIViewController <Alertable>  {
    UITextField *_email;
    UITextField *_password;
    UIButton    *_loginButton;
    DataFactory *_factory;
}

@property(nonatomic, retain) IBOutlet UITextField *email;
@property(nonatomic, retain) IBOutlet UITextField *password;
@property(nonatomic, retain) IBOutlet UIButton    *loginButton;
@property(nonatomic, retain) DataFactory *factory;

- (IBAction)loginClick:(id)sender;
- (IBAction)doneEmailEdit:(id)sender;
- (IBAction)donePasswordEdit:(id)sender;
- (IBAction)backTap:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
              factory:(DataFactory *)factory;

@end
