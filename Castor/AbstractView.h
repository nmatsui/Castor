//
//  AbstractView.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbstractView : UIViewController {
    BOOL _portrate;
}

- (void)alertException:(NSString *)message;

@end
