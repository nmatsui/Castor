//
//  GroupData.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GroupData.h"


@implementation GroupData

@synthesize roomId;
@synthesize roomName;

- (void)dealloc
{
    self.roomId = nil;
    self.roomName = nil;
    [super dealloc];
}
@end
