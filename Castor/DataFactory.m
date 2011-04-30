//
//  DataFactory.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataFactory.h"


@implementation DataFactory

- (NSMutableArray *)getGroupList
{
    NSMutableArray *list = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < 20; i++) {
        GroupData *groupData = [[[GroupData alloc] init] autorelease];
        groupData.roomId = [[NSNumber alloc] initWithInt:i];
        groupData.roomName = [NSString stringWithFormat:@"%d room",i];
        [list addObject:groupData];
    }
    return list;
}

- (NSMutableArray *)getRoomEntryListByRoomId:(NSNumber *)rId
{
    NSMutableArray *list = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < 20; i++) {
        EntryData *entryData = [[[EntryData alloc] init] autorelease];
        entryData.entryId = [[NSNumber alloc] initWithInt:i];
        entryData.roomId = rId;
        entryData.name = @"ほげほげ";
        NSString *str = [NSString stringWithFormat:@"[%d] %d entry",[rId intValue], i];
        for (int j = 0; j < i; j++) {
            str = [str stringByAppendingString:@"あいうえおかきくけこ"];
        }
        entryData.content = str;
        [list addObject:entryData];
    }
    return list;
}

@end
