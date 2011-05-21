//
//  CacheManager.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface CacheManager : NSObject {
    sqlite3 *_db;
}

- (NSData *)selectRoomIconAtRoomId:(NSNumber *)roomId;
- (void)insertOrReplaceRoomIconAtRoomId:(NSNumber *)roomId icon:(NSData *)icon;
- (void)deleteAllRoomIcon;

- (NSData *)selectParticipationIconAtRoomId:(NSNumber *)roomId participationId:(NSNumber *)participationId;
- (void)insertOrReplaceParticipationIconAtRoomId:(NSNumber *)roomId participationId:(NSNumber *)participationId icon:(NSData *)icon;
- (void)deleteAllParticipationIcon;

- (NSData *)selectHomeTimeline;
- (void)insertOrReplaceHomeTimeline:(NSData *)timeline;
- (void)deleteAllHomeTimeline;

- (NSData *)selectRoomList;
- (void)insertOrReplaceRoomList:(NSData *)list;
- (void)deleteAllRoomList;

- (NSData *)selectRoomTimelineAtRoomId:(NSNumber *)roomId;
- (void)insertOrReplaceRoomTimelineAtRoomId:(NSNumber *)roomId timeline:(NSData *)timeline;
- (void)deleteAllRoomTimeline;

- (NSData *)selectEntriesAtRoomId:(NSNumber *)roomId entryId:(NSNumber *)entryId;
- (void)insertOrReplaceEntriesAtRoomId:(NSNumber *)roomId entryId:(NSNumber *)entryId entries:(NSData *)entries;
- (void)deleteAllEntries;

@end
