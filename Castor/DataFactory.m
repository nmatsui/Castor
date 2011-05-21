//
//  DataFactory.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataFactory.h"

@interface DataFactory (Private)
- (void)_appendEntry:(NSMutableArray *)entryList list:(NSMutableArray *)list;
@end

@implementation DataFactory

@synthesize authTokenPath = _authTokenPath;
@synthesize gateway = _gateway;
@synthesize cacheManager = _cacheManager;

- (id)init
{
    self = [super init];
    if(self){
        self.authTokenPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"oauth_token"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.authTokenPath]) {
            NSData *data = [[[NSData alloc] initWithContentsOfFile:self.authTokenPath] autorelease];
            NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            NSLog(@"find token from cache %@:%@", [dict objectForKey:@"oauth_token"], [dict objectForKey:@"oauth_token_secret"]);
            self.gateway = [[YouRoomGateway alloc] initWithOAuthToken:[dict objectForKey:@"oauth_token"] oAuthTokenSecret:[dict objectForKey:@"oauth_token_secret"]];
        }
        else {
            NSLog(@"can't find token from cache");
            self.gateway = [[YouRoomGateway alloc] init];
        }
        self.cacheManager = [[CacheManager alloc] init];
    }
    return self;
}

- (void)dealloc
{
    self.authTokenPath = nil;
    self.gateway = nil;
    self.cacheManager = nil;
    [super dealloc];
}

- (BOOL)storeAuthTokenWithEmail:(NSString *)email password:(NSString *)password sender:(UIViewController <Alertable> *)sender
{
    BOOL result = NO;
    @try {
        [self clearAuthToken];
        NSDictionary *dict = [self.gateway retrieveAuthTokenWithEmail:email password:password];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
        [data writeToFile:self.authTokenPath atomically:YES];
        NSLog(@"store token to cache %@:%@", [dict objectForKey:@"oauth_token"], [dict objectForKey:@"oauth_token_secret"]);
        result = YES;
    }
    @catch (NSException *exception) {
        NSLog(@"exception in storeAuthTokenWithEmail[%@]", [exception reason]);
        [sender performSelectorOnMainThread:@selector(alertException:) withObject:[exception reason] waitUntilDone:YES];
    }
    @finally {
        return result;
    }
}

- (BOOL)hasAuthToken
{
    return [[NSFileManager defaultManager] fileExistsAtPath:self.authTokenPath];
}

- (void)clearAuthToken
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.authTokenPath]) [[NSFileManager defaultManager] removeItemAtPath:self.authTokenPath error:nil];
}

- (NSMutableArray *)getHomeTimelineFromCache
{
    NSLog(@"getHomeTimelineFromCache");
    return nil;
}

- (NSMutableArray *)getHomeTimelineWithSender:(UIViewController <Alertable> *)sender
{
    NSLog(@"getHomeTimelineWithSender");
    NSMutableArray *homeList = [[NSMutableArray alloc] init];
    
    EntryData *entry11 = [[EntryData alloc] init];
    entry11.entryId = [[NSNumber alloc] initWithInt:11];
    entry11.participationName = @"name11";
    entry11.content = @"entry11";
    entry11.level = 0;
    
    EntryData *entry12 = [[EntryData alloc] init];
    entry12.entryId = [[NSNumber alloc] initWithInt:12];
    entry12.participationName = @"name12";
    entry12.content = @"entry12";
    entry12.level = 0;
    
    EntryData *entry13 = [[EntryData alloc] init];
    entry13.entryId = [[NSNumber alloc] initWithInt:123];
    entry13.participationName = @"name13";
    entry13.content = @"entry13wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww";
    entry13.level = 0;
    
    RoomData *room1 = [[RoomData alloc] init];
    room1.roomId = [[NSNumber alloc] initWithInt:1];
    room1.roomName = @"room1";
    room1.entries = [[NSMutableArray alloc] initWithObjects:entry11, entry12, entry13, nil];
    
    [homeList addObject:room1];
    
    EntryData *entry21 = [[EntryData alloc] init];
    entry21.entryId = [[NSNumber alloc] initWithInt:21];
    entry21.participationName = @"name21";
    entry21.content = @"entry21";
    entry21.level = 0;
    
    EntryData *entry22 = [[EntryData alloc] init];
    entry22.entryId = [[NSNumber alloc] initWithInt:22];
    entry22.participationName = @"name22";
    entry22.content = @"entry22";
    entry22.level = 0;
    
    EntryData *entry23 = [[EntryData alloc] init];
    entry23.entryId = [[NSNumber alloc] initWithInt:23];
    entry23.participationName = @"name23";
    entry23.content = @"entry23";
    entry23.level = 0;
    
    EntryData *entry24 = [[EntryData alloc] init];
    entry24.entryId = [[NSNumber alloc] initWithInt:24];
    entry24.participationName = @"name24";
    entry24.content = @"entry24;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
    entry24.level = 0;
    
    EntryData *entry25 = [[EntryData alloc] init];
    entry25.entryId = [[NSNumber alloc] initWithInt:25];
    entry25.participationName = @"name25";
    entry25.content = @"entry25;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;";
    entry25.level = 0;
    
    RoomData *room2 = [[RoomData alloc] init];
    room2.roomId = [[NSNumber alloc] initWithInt:2];
    room2.roomName = @"room2";
    room2.entries = [[NSMutableArray alloc] initWithObjects:entry21, entry22, entry23, entry24, entry25, nil];
    
    [homeList addObject:room2];
    
    return homeList;
}

- (NSMutableArray *)getRoomListFromCache
{
    NSLog(@"getRoomListFromCache");
    NSData *data = [self.cacheManager selectRoomList];
    if (data != nil) {
        NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [data release];
        return array;
    }
    else {
        return nil;
    }
}

- (NSMutableArray *)getRoomListWithSender:(UIViewController <Alertable> *)sender
{
    NSLog(@"getRoomListWithSender");
    NSMutableArray *list = nil;
    @try {
        list = [self.gateway retrieveRoomList];
        [self.cacheManager insertOrReplaceRoomList:[NSKeyedArchiver archivedDataWithRootObject:list]];
    }
    @catch (NSException *exception) {
        NSLog(@"exception in getRoomListWithSender[%@]", [exception reason]);
        [sender performSelectorOnMainThread:@selector(alertException:) withObject:[exception reason] waitUntilDone:YES];
    }
    return list;
}

- (NSMutableArray *)getRoomEntryListFromCache:(NSNumber *)roomId
{
    NSLog(@"getRoomEntryListFromCache[%@]", roomId);
    NSData *data = [self.cacheManager selectRoomTimelineAtRoomId:roomId];
    if (data != nil) {
        NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [data release];
        return array;
    }
    else {
        return nil;
    }
}

- (NSMutableArray *)getRoomEntryListByRoomId:(NSNumber *)roomId page:(int)page sender:(UIViewController <Alertable> *)sender
{
    NSLog(@"getRoomEntryListByRoomId[%@] page[%d]", roomId, page);
    NSMutableArray *list = [[[NSMutableArray alloc] init] autorelease];
    @try {
        for (int i = 1; i <= page; i++) {
            [list addObjectsFromArray:[self.gateway retrieveEntryListByRoomId:roomId page:i]];
        }
        [self.cacheManager insertOrReplaceRoomTimelineAtRoomId:roomId timeline:[NSKeyedArchiver archivedDataWithRootObject:list]];
    }
    @catch (NSException *exception) {
        NSLog(@"exception in getRoomEntryListByRoomId [%@]", [exception reason]);
        [sender performSelectorOnMainThread:@selector(alertException:) withObject:[exception reason] waitUntilDone:YES];
    }
    return list;
}

- (NSMutableArray *)getEntryCommentListFromCache:(EntryData *)entry
{
    NSLog(@"getEntryCommentListFromCache[%@][%@]", entry.roomId, entry.entryId);
    NSData *data = [self.cacheManager selectEntriesAtRoomId:entry.roomId entryId:entry.entryId];
    if (data != nil) {
        NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [data release];
        return array;
    }
    else {
        return nil;
    }
}

- (NSMutableArray *)getEntryCommentListByEntryData:(EntryData *)entry sender:(UIViewController <Alertable> *)sender
{
    NSLog(@"getEntryCommentListByEntryData[%@]", entry.entryId);
    NSMutableArray *list = [[[NSMutableArray alloc] init] autorelease];
    @try {
        [self _appendEntry:[self.gateway retrieveEntryCommentListByEntryId:entry.entryId roomId:entry.roomId] list:list];
        [self.cacheManager insertOrReplaceEntriesAtRoomId:entry.roomId entryId:entry.entryId entries:[NSKeyedArchiver archivedDataWithRootObject:list]];
    }
    @catch (NSException *exception) {
        NSLog(@"exception in getEntryCommentListByEntryData [%@]", [exception reason]);
        [sender performSelectorOnMainThread:@selector(alertException:) withObject:[exception reason] waitUntilDone:YES];
    }
    return list;
}

- (void)addEntryText:(NSString *)text roomId:(NSNumber *)roomId parentId:(NSNumber *)parentId sender:(UIViewController <Alertable> *)sender
{
    NSLog(@"addEntryText[%@] roomId[%@] parentId[%@]", text, roomId, parentId);
    @try {
        [self.gateway postEntryText:text roomId:roomId parentId:parentId];
    }
    @catch (NSException *exception) {
        NSLog(@"exception in addEntryText [%@]", [exception reason]);
        [sender performSelectorOnMainThread:@selector(alertException:) withObject:[exception reason] waitUntilDone:YES];
    }
}

- (void)updateEntryText:(NSString *)text roomId:(NSNumber *)roomId entryId:(NSNumber *)entryId sender:(UIViewController <Alertable> *)sender
{
    NSLog(@"updateEntryText[%@] roomId[%@] entryId[%@]", text, roomId, entryId);
    @try {
        [self.gateway putEntryText:text roomId:roomId entryId:entryId];
    }
    @catch (NSException *exception) {
        NSLog(@"exception in updateEntryText [%@]", [exception reason]);
        [sender performSelectorOnMainThread:@selector(alertException:) withObject:[exception reason] waitUntilDone:YES];
    }
}

- (void)deleteEntryByEntryId:(NSNumber *)entryId roomId:(NSNumber *)roomId sender:(UIViewController <Alertable> *)sender
{
    NSLog(@"deleteEntryByEntryId[%@] roomId[%@]", entryId, roomId);
    @try {
        [self.gateway deleteEntryByEntryId:entryId roomId:roomId];
    }
    @catch (NSException *exception) {
        NSLog(@"exception in deleteEntryByEntryId [%@]", [exception reason]);
        [sender performSelectorOnMainThread:@selector(alertException:) withObject:[exception reason] waitUntilDone:YES];
    }
}

- (UIImage *)getAttachmentImageByEntryData:(EntryData *)entry sender:(UIViewController <Alertable> *)sender
{
    NSLog(@"getAttachmentImage[%@]", entry.entryId);
    UIImage *image = nil;
    @try {
        image = [self.gateway retrieveEntryAttachmentImageByEntryId:entry.entryId roomId:entry.roomId];
    }
    @catch (NSException *exception) {
        NSLog(@"exception in getAttachmentImageByEntryData [%@]", [exception reason]);
        [sender performSelectorOnMainThread:@selector(alertException:) withObject:[exception reason] waitUntilDone:YES];
    }
    return image;
}

- (UIImage *)getRoomIconByRoomId:(NSNumber *)roomId
{
    NSLog(@"getRoomIconByRoomId[%@]", roomId);
    NSData *icon = [self.cacheManager selectRoomIconAtRoomId:roomId];
    if (icon == nil) {
        @try {
            icon = [self.gateway retrieveRoomIconByRoomId:roomId];
            [self.cacheManager insertOrReplaceRoomIconAtRoomId:roomId icon:icon];
        }
        @catch (NSException *exception) {
            NSLog(@"exception in getAttachmentImageByEntryData [%@]", [exception reason]);
            // Icon読み込みに失敗しても、エラーダイアログは出さない
        }
    }
    return [[[UIImage alloc] initWithData:icon] autorelease];
}

- (UIImage *)getParticipationIconByRoomId:(NSNumber *)roomId participationId:(NSNumber *)participationId
{
    NSLog(@"getParticipationIconByRoomId[%@] participationId[%@]", roomId, participationId);
    NSData *icon = [self.cacheManager selectParticipationIconAtRoomId:roomId participationId:participationId];
    if (icon == nil) {
        @try {
            icon = [self.gateway retrieveParticipationIconByRoomId:roomId participationId:participationId];
            [self.cacheManager insertOrReplaceParticipationIconAtRoomId:roomId participationId:participationId icon:icon];
        }
        @catch (NSException *exception) {
            NSLog(@"exception in getAttachmentImageByEntryData [%@]", [exception reason]);
            // Icon読み込みに失敗しても、エラーダイアログは出さない
        }
    }
    return [[[UIImage alloc] initWithData:icon] autorelease];
}

- (void)deleteCache
{
    [self.cacheManager deleteAllRoomIcon];
    [self.cacheManager deleteAllParticipationIcon];
    [self.cacheManager deleteAllRoomList];
    [self.cacheManager deleteAllRoomTimeline];
    [self.cacheManager deleteAllEntries];
}

//// Private
- (void)_appendEntry:(NSMutableArray *)entryList list:(NSMutableArray *)list
{
    for (EntryData *data in entryList) {
        [list addObject:data];
        if (data.children != nil && [data.children count] != 0) {
            [self _appendEntry:data.children list:list];
        }
    }
}

@end
