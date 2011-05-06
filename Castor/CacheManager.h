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

- (NSData *)selectGroupIconAtRoomId:(NSNumber *)roomId;
- (void)insertOrReplaceGroupIconAtRoomId:(NSNumber *)roomId icon:(NSData *)icon;
- (void)deleteAllGroupIcon;

- (NSData *)selectParticipationIconAtRoomId:(NSNumber *)roomId participationId:(NSNumber *)participationId;
- (void)insertOrReplaceParticipationIconAtRoomId:(NSNumber *)roomId participationId:(NSNumber *)participationId icon:(NSData *)icon;
- (void)deleteAllParticipationIcon;
@end