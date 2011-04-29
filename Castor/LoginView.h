//
//  LoginView.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupView.h"


@interface LoginView : UIViewController {
    IBOutlet UITextField *email;
    IBOutlet UITextField *password;
    IBOutlet UIButton    *loginButton;
}
-(IBAction) loginClick:(id)sender;
-(IBAction) doneEmailEdit:(id)sender;
-(IBAction) donePasswordEdit:(id)sender;
-(IBAction) backTap:(id)sender;

@end
