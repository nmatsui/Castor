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
@synthesize participantName;
@synthesize content;
@synthesize level;
@synthesize participantIcon;
@synthesize attachmentType;
@synthesize attachmentText;
@synthesize attachmentImage;

- (void)dealloc
{
    self.entryId = nil;
    self.roomId = nil;
    self.participantName = nil;
    self.content = nil;
    self.level = nil;
    self.participantIcon = nil;
    self.attachmentType = nil;
    self.attachmentText = nil;
    self.attachmentImage = nil;
    [super dealloc];
}
@end