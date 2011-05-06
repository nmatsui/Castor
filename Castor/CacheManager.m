//
//  CacheManager.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/06.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CacheManager.h"

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

- (NSData *)selectGroupIconAtRoomId:(NSNumber *)roomId
{
    NSLog(@"selectGroupIconAtRoomId[%@]", roomId);
    NSString *sql = @"select icon, size from group_icon_cache where room_id = @roomId";
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"statement error at selectGroupIconAtRoomId" userInfo:nil];
        [exception raise];
    };
    sqlite3_bind_int(statement, sqlite3_bind_parameter_index(statement, "@roomId"), [roomId intValue]);
    NSData *image = nil;
    if (sqlite3_step(statement) == SQLITE_ROW) {
        image = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 0) length:sqlite3_column_int(statement, 1)];
    }
    sqlite3_finalize(statement);
    return image;
}

- (void)insertOrReplaceGroupIconAtRoomId:(NSNumber *)roomId icon:(NSData *)icon
{
    NSLog(@"insertOrReplaceGroupIconAtRoomId[%@]", roomId);
    NSString *sql = @"insert or replace into group_icon_cache(room_id, icon, size, cached_at) values(@roomId, @icon, @size, @cachedAt)";
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"statement error at insertOrReplaceGroupIconAtRoomId" userInfo:nil];
        [exception raise];
    };
    sqlite3_bind_int   (statement, sqlite3_bind_parameter_index(statement, "@roomId"),   [roomId intValue]);
    sqlite3_bind_blob  (statement, sqlite3_bind_parameter_index(statement, "@icon"),     [icon bytes], [icon length], NULL);
    sqlite3_bind_int   (statement, sqlite3_bind_parameter_index(statement, "@size"),     [icon length]);
    sqlite3_bind_double(statement, sqlite3_bind_parameter_index(statement, "@cachedAt"), [[NSDate date] timeIntervalSince1970]);
    if (sqlite3_step(statement) == SQLITE_ERROR) {
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"insert or replace error at insertOrReplaceGroupIconAtRoomId" userInfo:nil];
        [exception raise];
    }
    sqlite3_finalize(statement);
}

- (void)deleteAllGroupIcon
{
    NSLog(@"deleteAllGroupIcon");
    NSString *sql = @"delete from group_icon_cache";
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"statement error at deleteAllGroupIcon" userInfo:nil];
        [exception raise];
    };
    if (sqlite3_step(statement) == SQLITE_ERROR) {
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"delete error at deleteAllGroupIcon" userInfo:nil];
        [exception raise];
    }
    sqlite3_finalize(statement);
}

- (NSData *)selectParticipationIconAtRoomId:(NSNumber *)roomId participationId:(NSNumber *)participationId
{
    NSLog(@"selectParticipationIconAtRoomId[%@] participationId[%@]", roomId, participationId);
    NSString *sql = @"select icon, size from participation_icon_cache where room_id = @roomId and participation_id = @participationId";
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
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
    return image;
}

- (void)insertOrReplaceParticipationIconAtRoomId:(NSNumber *)roomId participationId:(NSNumber *)participationId icon:(NSData *)icon
{
    NSLog(@"insertOrReplaceParticipationIconAtRoomId[%@] participationId[%@]", roomId, participationId);
    NSString *sql = @"insert or replace into participation_icon_cache(room_id, participation_id, icon, size, cached_at) values(@roomId, @participationId, @icon, @size, @cachedAt)";
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"statement error at insertOrReplaceParticipationIconAtRoomId" userInfo:nil];
        [exception raise];
    };
    sqlite3_bind_int   (statement, sqlite3_bind_parameter_index(statement, "@roomId"),          [roomId intValue]);
    sqlite3_bind_int   (statement, sqlite3_bind_parameter_index(statement, "@participationId"), [participationId intValue]);
    sqlite3_bind_blob  (statement, sqlite3_bind_parameter_index(statement, "@icon"),            [icon bytes], [icon length], NULL);
    sqlite3_bind_int   (statement, sqlite3_bind_parameter_index(statement, "@size"),            [icon length]);
    sqlite3_bind_double(statement, sqlite3_bind_parameter_index(statement, "@cachedAt"),        [[NSDate date] timeIntervalSince1970]);
    if (sqlite3_step(statement) == SQLITE_ERROR) {
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"insert or replace error at insertOrReplaceParticipationIconAtRoomId" userInfo:nil];
        [exception raise];
    }
    sqlite3_finalize(statement);
}

- (void)deleteAllParticipationIcon
{
    NSLog(@"deleteAllParticipationIcon");
    NSString *sql = @"delete from participation_icon_cache";
    sqlite3_stmt *statement = nil;
    if(sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"statement error at deleteAllParticipationIcon" userInfo:nil];
        [exception raise];
    };
    if (sqlite3_step(statement) == SQLITE_ERROR) {
        NSException* exception = [NSException exceptionWithName:@"SQLException" reason:@"delete error at deleteAllParticipationIcon" userInfo:nil];
        [exception raise];
    }
    sqlite3_finalize(statement);
}

@end
