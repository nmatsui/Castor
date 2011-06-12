//
//  GroupData.m
//  Castor
//
//  Copyright (C) 2011 Nobuyuki Matsui. All rights reserved.
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
@synthesize entries   = _entries;

- (void)dealloc
{
    self.roomId = nil;
    self.roomName = nil;
    self.roomIcon = nil;
    self.toParam = nil;
    self.createdAt = nil;
    self.updatedAt = nil;
    self.myId = nil;
    self.entries = nil;
    [super dealloc];
}

//// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.roomId    forKey:@"roomId"];
    [aCoder encodeObject:self.roomName  forKey:@"roomName"];
    [aCoder encodeBool:self.opend       forKey:@"opend"];
    [aCoder encodeObject:self.toParam   forKey:@"toParam"];
    [aCoder encodeObject:self.createdAt forKey:@"createdAt"];
    [aCoder encodeObject:self.updatedAt forKey:@"updatedAt"];
    [aCoder encodeBool:self.admin       forKey:@"admin"];
    [aCoder encodeObject:self.myId      forKey:@"myId"];
    [aCoder encodeObject:self.entries   forKey:@"entries"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.roomId    = [aDecoder decodeObjectForKey:@"roomId"];
    self.roomName  = [aDecoder decodeObjectForKey:@"roomName"];
    self.roomIcon  = nil;
    self.opend     = [aDecoder decodeBoolForKey:@"opend"];
    self.toParam   = [aDecoder decodeObjectForKey:@"toParam"];
    self.createdAt = [aDecoder decodeObjectForKey:@"createdAt"];
    self.admin     = [aDecoder decodeBoolForKey:@"admin"];
    self.myId      = [aDecoder decodeObjectForKey:@"myId"];
    self.entries   = [aDecoder decodeObjectForKey:@"entries"];
    return self;
}

@end
