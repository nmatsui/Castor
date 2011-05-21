    //
//  CacheManager.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CacheManager.h"

@interface CacheManager (Private)
- (void)beginTransaction;
- (void)commit;
- (void)rollback;
@end

@implementation CacheManager

- (id)init
{
    self = [super init];
    if(self){
        NSString *databaseName = @"database.sqlite";
        NSString *sqlitePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:databaseName];
        if (![[NSFileManager defaultManager] fileExistsAtPath:sqlitePath]) {
            NSError *error = nil;
            NSString *templatePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
            [[NSFileManager defaultManager] copyItemAtPath:templatePath toPath:sqlitePath error:&error];
        }
        if (sqlite3_open([sqlitePath UTF8String], &_db) != SQLITE_OK) {
            NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"can't open database" userInfo:nil];
            [exception raise];
        }
        NSLog(@"database open");
    }
    return self;
}

- (void)dealloc
{
    sqlite3_close(_db);
    NSLog(@"database close");
    [super dealloc];
}

- (NSData *)selectRoomIconAtRoomId:(NSNumber *)roomId
{
    NSLog(@"selectRoomIconAtRoomId[%@]", roomId);
    [self beginTransaction];
    NSString *sql = @"select icon, size from room_icon_cache where room_id = @roomId";
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"statement error at selectRoomIconAtRoomId" userInfo:nil];
        [exception raise];
    };
    sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, "@roomId"), [roomId intValue]);
    NSData *image = nil;
    if (sqlite3_step(statement) == SQLITE_ROW) {
        image = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 0) length:sqlite3_column_int(statement, 1)];
    }
    sqlite3_finalize(statement);
    [self commit];
    return image;
}
- (void)insertOrReplaceRoomIconAtRoomId:(NSNumber *)roomId icon:(NSData *)icon
{
    NSLog(@"insertOrReplaceRoomIconAtRoomId[%@]", roomId);
    [self beginTransaction];
    NSString *sql = @"insert or replace into room_icon_cache(room_id, icon, size, cached_at) values(@roomId, @icon, @size, @cachedAt)";
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"statement error at insertOrReplaceRoomIconAtRoomId" userInfo:nil];
        [exception raise];
    };
    sqlite3_bind_int   (statement, sqlite3_bind_parameter_index(statement, "@roomId"),   [roomId intValue]);
    sqlite3_bind_blob  (statement, sqlite3_bind_parameter_index(statement, "@icon"),     [icon bytes], [icon length], SQLITE_TRANSIENT);
    sqlite3_bind_int   (statement, sqlite3_bind_parameter_index(statement, "@size"),     [icon length]);
    sqlite3_bind_double(statement, sqlite3_bind_parameter_index(statement, "@cachedAt"), [[NSDate date] timeIntervalSince1970]);
    if (sqlite3_step(statement) == SQLITE_ERROR) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"insert or replace error at insertOrReplaceRoomIconAtRoomId" userInfo:nil];
        [exception raise];
    }
    sqlite3_finalize(statement);
    [self commit];
}
- (void)deleteAllRoomIcon
{
    NSLog(@"deleteAllRoomIcon");
    [self beginTransaction];
    NSString *sql = @"delete from room_icon_cache";
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"statement error at deleteAllRoomIcon" userInfo:nil];
        [exception raise];
    };
    if (sqlite3_step(statement) == SQLITE_ERROR) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"delete error at deleteAllRoomIcon" userInfo:nil];
        [exception raise];
    }
    sqlite3_finalize(statement);
    [self commit];
}

- (NSData *)selectParticipationIconAtRoomId:(NSNumber *)roomId participationId:(NSNumber *)participationId
{
    NSLog(@"selectParticipationIconAtRoomId[%@] participationId[%@]", roomId, participationId);
    [self beginTransaction];
    NSString *sql = @"select icon, size from participation_icon_cache where room_id = @roomId and participation_id = @participationId";
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"statement error at selectParticipationIconAtRoomId" userInfo:nil];
        [exception raise];
    };
    sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, "@roomId"),          [roomId intValue]);
    sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, "@participationId"), [participationId intValue]);
    NSData *image = nil;
    if (sqlite3_step(statement) == SQLITE_ROW) {
        image = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 0) length:sqlite3_column_int(statement, 1)];
    }
    sqlite3_finalize(statement);
    [self commit];
    return image;
}
- (void)insertOrReplaceParticipationIconAtRoomId:(NSNumber *)roomId participationId:(NSNumber *)participationId icon:(NSData *)icon
{
    NSLog(@"insertOrReplaceParticipationIconAtRoomId[%@] participationId[%@]", roomId, participationId);
    [self beginTransaction];
    NSString *sql = @"insert or replace into participation_icon_cache(room_id, participation_id, icon, size, cached_at) values(@roomId, @participationId, @icon, @size, @cachedAt)";
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"statement error at insertOrReplaceParticipationIconAtRoomId" userInfo:nil];
        [exception raise];
    };
    sqlite3_bind_int   (statement, sqlite3_bind_parameter_index(statement, "@roomId"),          [roomId intValue]);
    sqlite3_bind_int   (statement, sqlite3_bind_parameter_index(statement, "@participationId"), [participationId intValue]);
    sqlite3_bind_blob  (statement, sqlite3_bind_parameter_index(statement, "@icon"),            [icon bytes], [icon length], SQLITE_TRANSIENT);
    sqlite3_bind_int   (statement, sqlite3_bind_parameter_index(statement, "@size"),            [icon length]);
    sqlite3_bind_double(statement, sqlite3_bind_parameter_index(statement, "@cachedAt"),        [[NSDate date] timeIntervalSince1970]);
    if (sqlite3_step(statement) == SQLITE_ERROR) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"insert or replace error at insertOrReplaceParticipationIconAtRoomId" userInfo:nil];
        [exception raise];
    }
    sqlite3_finalize(statement);
    [self commit];
}
- (void)deleteAllParticipationIcon
{
    NSLog(@"deleteAllParticipationIcon");
    [self beginTransaction];
    NSString *sql = @"delete from participation_icon_cache";
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"statement error at deleteAllParticipationIcon" userInfo:nil];
        [exception raise];
    };
    if (sqlite3_step(statement) == SQLITE_ERROR) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"delete error at deleteAllParticipationIcon" userInfo:nil];
        [exception raise];
    }
    sqlite3_finalize(statement);
    [self commit];
}

- (NSData *)selectHomeTimeline
{
    NSLog(@"selectHomeTimeline");
    [self beginTransaction];
    NSString *sql = @"select timeline, size from home_timeline_cache";
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"statement error at selectHomeTimeline" userInfo:nil];
        [exception raise];
    };
    NSData *timeline = nil;
    if (sqlite3_step(statement) == SQLITE_ROW) {
        timeline = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 0) length:sqlite3_column_int(statement, 1)];
    }
    sqlite3_finalize(statement);
    [self commit];
    return timeline;
}
- (void)insertOrReplaceHomeTimeline:(NSData *)timeline
{
    NSLog(@"insertOrReplaceHomeTimeline");
    [self beginTransaction];
    NSString *sql = @"insert or replace into home_timeline_cache(pseud_id, timeline, size, cached_at) values(1, @timeline, @size, @cachedAt)"; // 最新１データだけ持てば良いので、PKは必ず1
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"statement error at insertOrReplaceHomeTimeline" userInfo:nil];
        [exception raise];
    };
    sqlite3_bind_blob  (statement, sqlite3_bind_parameter_index(statement, "@timeline"), [timeline bytes], [timeline length], SQLITE_TRANSIENT);
    sqlite3_bind_int   (statement, sqlite3_bind_parameter_index(statement, "@size"),     [timeline length]);
    sqlite3_bind_double(statement, sqlite3_bind_parameter_index(statement, "@cachedAt"), [[NSDate date] timeIntervalSince1970]);
    if (sqlite3_step(statement) == SQLITE_ERROR) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"insert or replace error at insertOrReplaceHomeTimeline" userInfo:nil];
        [exception raise];
    }
    sqlite3_finalize(statement);
    [self commit];
}
- (void)deleteAllHomeTimeline
{
    NSLog(@"deleteAllHomeTimeline");
    [self beginTransaction];
    NSString *sql = @"delete from home_timeline_cache";
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"statement error at deleteAllHomeTimeline" userInfo:nil];
        [exception raise];
    };
    if (sqlite3_step(statement) == SQLITE_ERROR) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"delete error at deleteAllHomeTimeline" userInfo:nil];
        [exception raise];
    }
    sqlite3_finalize(statement);
    [self commit];
}

- (NSData *)selectRoomList
{
    NSLog(@"selectRoomList");
    [self beginTransaction];
    NSString *sql = @"select list, size from room_list_cache";
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"statement error at selectRoomList" userInfo:nil];
        [exception raise];
    };
    NSData *list = nil;
    if (sqlite3_step(statement) == SQLITE_ROW) {
        list = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 0) length:sqlite3_column_int(statement, 1)];
    }
    sqlite3_finalize(statement);
    [self commit];
    return list;
}
- (void)insertOrReplaceRoomList:(NSData *)list
{
    NSLog(@"insertOrReplaceRoomList");
    [self beginTransaction];
    NSString *sql = @"insert or replace into room_list_cache(pseud_id, list, size, cached_at) values(1, @list, @size, @cachedAt)"; // 最新１データだけ持てば良いので、PKは必ず1
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"statement error at insertOrReplaceRoomList" userInfo:nil];
        [exception raise];
    };
    sqlite3_bind_blob  (statement, sqlite3_bind_parameter_index(statement, "@list"),     [list bytes], [list length], SQLITE_TRANSIENT);
    sqlite3_bind_int   (statement, sqlite3_bind_parameter_index(statement, "@size"),     [list length]);
    sqlite3_bind_double(statement, sqlite3_bind_parameter_index(statement, "@cachedAt"), [[NSDate date] timeIntervalSince1970]);
    if (sqlite3_step(statement) == SQLITE_ERROR) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"insert or replace error at insertOrReplaceRoomList" userInfo:nil];
        [exception raise];
    }
    sqlite3_finalize(statement);
    [self commit];
}
- (void)deleteAllRoomList
{
    NSLog(@"deleteAllRoomList");
    [self beginTransaction];
    NSString *sql = @"delete from room_list_cache";
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"statement error at deleteAllRoomList" userInfo:nil];
        [exception raise];
    };
    if (sqlite3_step(statement) == SQLITE_ERROR) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"delete error at deleteAllRoomList" userInfo:nil];
        [exception raise];
    }
    sqlite3_finalize(statement);
    [self commit];
}

- (NSData *)selectRoomTimelineAtRoomId:(NSNumber *)roomId
{
    NSLog(@"selectRoomTimelineAtRoomId[%@]", roomId);
    [self beginTransaction];
    NSString *sql = @"select timeline, size from room_timeline_cache where room_id = @roomId";
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"statement error at selectRoomTimelineAtRoomId" userInfo:nil];
        [exception raise];
    };
    sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, "@roomId"), [roomId intValue]);
    NSData *timeline = nil;
    if (sqlite3_step(statement) == SQLITE_ROW) {
        timeline = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 0) length:sqlite3_column_int(statement, 1)];
    }
    sqlite3_finalize(statement);
    [self commit];
    return timeline;
}
- (void)insertOrReplaceRoomTimelineAtRoomId:(NSNumber *)roomId timeline:(NSData *)timeline
{
    NSLog(@"insertOrReplaceRoomTimelineAtRoomId[%@]", roomId);
    [self beginTransaction];
    NSString *sql = @"insert or replace into room_timeline_cache(room_id, timeline, size, cached_at) values(@roomId, @timeline, @size, @cachedAt)";
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"statement error at insertOrReplaceRoomTimelineAtRoomId" userInfo:nil];
        [exception raise];
    };
    sqlite3_bind_int   (statement, sqlite3_bind_parameter_index(statement, "@roomId"),   [roomId intValue]);
    sqlite3_bind_blob  (statement, sqlite3_bind_parameter_index(statement, "@timeline"), [timeline bytes], [timeline length], SQLITE_TRANSIENT);
    sqlite3_bind_int   (statement, sqlite3_bind_parameter_index(statement, "@size"),     [timeline length]);
    sqlite3_bind_double(statement, sqlite3_bind_parameter_index(statement, "@cachedAt"), [[NSDate date] timeIntervalSince1970]);
    if (sqlite3_step(statement) == SQLITE_ERROR) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"insert or replace error at insertOrReplaceRoomTimelineAtRoomId" userInfo:nil];
        [exception raise];
    }
    sqlite3_finalize(statement);
    [self commit];
}
- (void)deleteAllRoomTimeline
{
    NSLog(@"deleteAllRoomTimeline");
    [self beginTransaction];
    NSString *sql = @"delete from room_timeline_cache";
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"statement error at deleteAllRoomTimeline" userInfo:nil];
        [exception raise];
    };
    if (sqlite3_step(statement) == SQLITE_ERROR) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"delete error at deleteAllRoomTimeline" userInfo:nil];
        [exception raise];
    }
    sqlite3_finalize(statement);
    [self commit];
}

- (NSData *)selectEntriesAtRoomId:(NSNumber *)roomId entryId:(NSNumber *)entryId
{
    NSLog(@"selectEntriesAtRoomId[%@] entryId[%@]", roomId, entryId);
    [self beginTransaction];
    NSString *sql = @"select entries, size from entries_cache where room_id = @roomId and entry_id = @entry_id";
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"statement error at selectEntriesAtRoomId" userInfo:nil];
        [exception raise];
    };
    sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, "@roomId"),   [roomId intValue]);
    sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, "@entry_id"), [entryId intValue]);
    NSData *entries = nil;
    if (sqlite3_step(statement) == SQLITE_ROW) {
        entries = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 0) length:sqlite3_column_int(statement, 1)];
    }
    sqlite3_finalize(statement);
    [self commit];
    return entries;
}
- (void)insertOrReplaceEntriesAtRoomId:(NSNumber *)roomId entryId:(NSNumber *)entryId entries:(NSData *)entries
{
    NSLog(@"insertOrReplaceEntriesAtRoomId[%@] participationId[%@]", roomId, entryId);
    [self beginTransaction];
    NSString *sql = @"insert or replace into entries_cache(room_id, entry_id, entries, size, cached_at) values(@roomId, @entryId, @entries, @size, @cachedAt)";
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"statement error at insertOrReplaceEntriesAtRoomId" userInfo:nil];
        [exception raise];
    };
    sqlite3_bind_int   (statement, sqlite3_bind_parameter_index(statement, "@roomId"),   [roomId intValue]);
    sqlite3_bind_int   (statement, sqlite3_bind_parameter_index(statement, "@entryId"),  [entryId intValue]);
    sqlite3_bind_blob  (statement, sqlite3_bind_parameter_index(statement, "@entries"),  [entries bytes], [entries length], SQLITE_TRANSIENT);
    sqlite3_bind_int   (statement, sqlite3_bind_parameter_index(statement, "@size"),     [entries length]);
    sqlite3_bind_double(statement, sqlite3_bind_parameter_index(statement, "@cachedAt"), [[NSDate date] timeIntervalSince1970]);
    if (sqlite3_step(statement) == SQLITE_ERROR) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"insert or replace error at insertOrReplaceEntriesAtRoomId" userInfo:nil];
        [exception raise];
    }
    sqlite3_finalize(statement);
    [self commit];
}
- (void)deleteAllEntries
{
    NSLog(@"deleteAllEntries");
    [self beginTransaction];
    NSString *sql = @"delete from entries_cache";
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"statement error at deleteAllEntries" userInfo:nil];
        [exception raise];
    };
    if (sqlite3_step(statement) == SQLITE_ERROR) {
        [self rollback];
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"delete error at deleteAllEntries" userInfo:nil];
        [exception raise];
    }
    sqlite3_finalize(statement);
    [self commit];
}

//// Private
- (void)beginTransaction
{
    sqlite3_exec(_db, "BEGIN", NULL, NULL, NULL );
}

- (void)commit
{
    sqlite3_exec(_db, "COMMIT", NULL, NULL, NULL );
}

- (void)rollback
{
    sqlite3_exec(_db, "ROLLBACK", NULL, NULL, NULL );
}

@end
