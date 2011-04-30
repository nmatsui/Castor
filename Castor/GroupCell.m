//
//  GroupCell.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GroupCell.h"


@implementation GroupCell

@synthesize groupName;

- (void)dealloc
{
    self.groupName = nil;
    [super dealloc];
}

@end
