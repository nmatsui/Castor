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
    sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, "@roomId"), [roomId intValue]);
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
