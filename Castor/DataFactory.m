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
@end
