//
//  BackgroundRect.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BackgroundRect : UIView {
    int _level;
}

- (id)initWithFrame:(CGRect)frame level:(int)level;
@end
