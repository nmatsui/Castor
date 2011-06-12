//
//  BackgroundRect.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/29.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BackgroundRect.h"

@implementation BackgroundRect

static const int INDENT_WIDTH = 10;
static const int RIGHT_MERGIN_WIDTH = 5;

- (id)initWithFrame:(CGRect)frame level:(int)level
{
    self = [super initWithFrame:frame];
    if (self) {
        _level = level;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    NSArray *colors = [NSArray arrayWithObjects:
                       [UIColor colorWithRed:0.910 green:0.950 blue:0.760 alpha:1.0],
                       [UIColor colorWithRed:0.820 green:0.940 blue:0.680 alpha:1.0],
                       [UIColor colorWithRed:0.800 green:0.950 blue:0.880 alpha:1.0],
                       [UIColor colorWithRed:0.640 green:0.910 blue:0.870 alpha:1.0],
                       [UIColor colorWithRed:0.440 green:0.870 blue:0.920 alpha:1.0],
                       [UIColor colorWithRed:0.640 green:0.780 blue:1.000 alpha:1.0],
                       nil];
    for (int i = 1; i <= _level; i++) {
        [[colors objectAtIndex:i-1] setFill];
        UIRectFill(CGRectMake(INDENT_WIDTH*i, 0, self.bounds.size.width-(INDENT_WIDTH+RIGHT_MERGIN_WIDTH)*i, self.bounds.size.height));
    }
}

- (void)dealloc
{
    [super dealloc];
}

@end
