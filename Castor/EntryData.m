//
//  EntryData.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EntryData.h"


@implementation EntryData

@synthesize entryId;
@synthesize roomId;
@synthesize name;
@synthesize content;

- (void)dealloc
{
    self.entryId = nil;
    self.roomId = nil;
    self.name = nil;
    self.content = nil;
    [super dealloc];
}
@end
