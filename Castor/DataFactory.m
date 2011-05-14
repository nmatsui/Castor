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
        self.gateway.cacheManager = self.cacheManager;
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

- (NSMutableArray *)getRoomListWithSender:(UIViewController <Alertable> *)sender
{
    NSLog(@"getRoomListWithSender");
    NSMutableArray *list = nil;
    @try {
        list = [self.gateway retrieveRoomList];
    }
    @catch (NSException *exception) {
        NSLog(@"exception in getRoomListWithSender[%@]", [exception reason]);
        [sender performSelectorOnMainThread:@selector(alertException:) withObject:[exception reason] waitUntilDone:YES];
    }
    return list;
}

- (NSMutableArray *)getRoomEntryListByRoomId:(NSNumber *)roomId page:(int)page sender:(UIViewController <Alertable> *)sender
{
    NSLog(@"getRoomEntryListByRoomId[%@] page[%d]", roomId, page);
    NSMutableArray *list = [[[NSMutableArray alloc] init] autorelease];
    @try {
        for (int i = 1; i <= page; i++) {
            [list addObjectsFromArray:[self.gateway retrieveEntryListByRoomId:roomId page:i]];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"exception in getRoomEntryListByRoomId [%@]", [exception reason]);
        [sender performSelectorOnMainThread:@selector(alertException:) withObject:[exception reason] waitUntilDone:YES];
    }
    return list;
}

- (NSMutableArray *)getEntryCommentListByEntryData:(EntryData *)entry sender:(UIViewController <Alertable> *)sender
{
    NSLog(@"getEntryCommentListByEntryData[%@]", entry.entryId);
    NSMutableArray *list = [[[NSMutableArray alloc] init] autorelease];
    @try {
        [self _appendEntry:[self.gateway retrieveEntryCommentListByEntryId:entry.entryId roomId:entry.roomId] list:list];
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

- (void)deleteCache
{
    [self.cacheManager deleteAllRoomIcon];
    [self.cacheManager deleteAllParticipationIcon];
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
