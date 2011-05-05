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
@end
