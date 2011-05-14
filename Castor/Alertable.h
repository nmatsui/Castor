//
//  Alertable.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol Alertable <NSObject>
- (void)alertException:(NSString *)message;
@end
