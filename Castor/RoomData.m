//
//  GroupData.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RoomData.h"


@implementation RoomData

@synthesize roomId    = _roomId;
@synthesize roomName  = _roomName;
@synthesize roomIcon  = _roomIcon;
@synthesize opend     = _opend;
@synthesize toParam   = _toParam;
@synthesize createdAt = _createdAt;
@synthesize updatedAt = _updatedAt;
@synthesize admin     = _admin;
@synthesize myId      = _myId;

- (void)dealloc
{
    self.roomId = nil;
    self.roomName = nil;
    self.roomIcon = nil;
    self.toParam = nil;
    self.createdAt = nil;
    self.updatedAt = nil;
    self.myId = nil;
    [super dealloc];
}
@end
