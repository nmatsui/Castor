//
//  EntryData.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EntryData.h"


@implementation EntryData

@synthesize entryId               = _entryId;
@synthesize roomId                = _roomId;
@synthesize content               = _content;
@synthesize parentId              = _parentId;
@synthesize rootId                = _rootId;
@synthesize participationId       = _participationId;
@synthesize participationName     = _participationName ;
@synthesize participationIcon     = _participationIcon;
@synthesize attachmentType        = _attachmentType;
@synthesize attachmentContentType = _attachmentContentType;
@synthesize attachmentText        = _attachmentText;
@synthesize attachmentURL         = _attachmentURL;
@synthesize attachmentFilename    = _attachmentFilename;
@synthesize children              = _children;
@synthesize descendantsCount      = _descendantsCount;
@synthesize createdAt             = _createdAt;
@synthesize updatedAt             = _updatedAt;
@synthesize level                 = _level;

- (void)dealloc
{
    self.entryId = nil;
    self.roomId = nil;
    self.content = nil;
    self.parentId = nil;
    self.rootId = nil;
    self.participationId = nil;
    self.participationName = nil;
    self.participationIcon = nil;
    self.attachmentType = nil;
    self.attachmentContentType = nil;
    self.attachmentText = nil;
    self.attachmentURL = nil;
    self.attachmentFilename = nil;
    self.children = nil;
    self.descendantsCount = nil;
    self.createdAt = nil;
    self.updatedAt = nil;
    self.level = nil;
    [super dealloc];
}

//// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.entryId               forKey:@"entryId"];
    [aCoder encodeObject:self.roomId                forKey:@"roomId"];
    [aCoder encodeObject:self.content               forKey:@"content"];
    [aCoder encodeObject:self.parentId              forKey:@"parentId"];
    [aCoder encodeObject:self.rootId                forKey:@"rootId"];
    [aCoder encodeObject:self.participationId       forKey:@"participationId"];
    [aCoder encodeObject:self.participationName     forKey:@"participationName"];
    [aCoder encodeObject:self.attachmentType        forKey:@"attachmentType"];
    [aCoder encodeObject:self.attachmentContentType forKey:@"attachmentContentType"];
    [aCoder encodeObject:self.attachmentText        forKey:@"attachmentText"];
    [aCoder encodeObject:self.attachmentURL         forKey:@"attachmentURL"];
    [aCoder encodeObject:self.attachmentFilename    forKey:@"attachmentFilename"];
    [aCoder encodeObject:self.children              forKey:@"children"];
    [aCoder encodeObject:self.descendantsCount      forKey:@"descendantsCount"];
    [aCoder encodeObject:self.createdAt             forKey:@"createdAt"];
    [aCoder encodeObject:self.updatedAt             forKey:@"updatedAt"];
    [aCoder encodeObject:self.level                 forKey:@"level"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.entryId               = [aDecoder decodeObjectForKey:@"entryId"];
    self.roomId                = [aDecoder decodeObjectForKey:@"roomId"];
    self.content               = [aDecoder decodeObjectForKey:@"content"];
    self.parentId              = [aDecoder decodeObjectForKey:@"parentId"];
    self.rootId                = [aDecoder decodeObjectForKey:@"rootId"];
    self.participationId       = [aDecoder decodeObjectForKey:@"participationId"];
    self.participationName     = [aDecoder decodeObjectForKey:@"participationName"];
    self.participationIcon     = nil;
    self.attachmentType        = [aDecoder decodeObjectForKey:@"attachmentType"];
    self.attachmentContentType = [aDecoder decodeObjectForKey:@"attachmentContentType"];
    self.attachmentText        = [aDecoder decodeObjectForKey:@"attachmentText"];
    self.attachmentURL         = [aDecoder decodeObjectForKey:@"attachmentURL"];
    self.attachmentFilename    = [aDecoder decodeObjectForKey:@"attachmentFilename"];
    self.children              = [aDecoder decodeObjectForKey:@"children"];
    self.descendantsCount      = [aDecoder decodeObjectForKey:@"descendantsCount"];
    self.createdAt             = [aDecoder decodeObjectForKey:@"creaedAt"];
    self.updatedAt             = [aDecoder decodeObjectForKey:@"updatedAt"];
    self.level                 = [aDecoder decodeObjectForKey:@"level"];
    return self;
}

@end
