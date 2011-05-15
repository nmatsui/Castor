//
//  DataFactory.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Alertable.h"
#import "RoomData.h"
#import "EntryData.h"
#import "YouRoomGateway.h"
#import "CacheManager.h"

@interface DataFactory : NSObject {
    NSString *_authTokenPath;
    YouRoomGateway *_gateway;
    CacheManager *_cacheManager;
}

@property(nonatomic, retain) NSString *authTokenPath;
@property(nonatomic, retain) YouRoomGateway *gateway;
@property(nonatomic, retain) CacheManager *cacheManager;

- (BOOL)storeAuthTokenWithEmail:(NSString *)email password:(NSString *)password sender:(UIViewController <Alertable> *)sender;
- (BOOL)hasAuthToken;
- (void)clearAuthToken;
- (NSMutableArray *)getRoomListFromCache;
- (NSMutableArray *)getRoomListWithSender:(UIViewController <Alertable> *)sender;
- (NSMutableArray *)getRoomEntryListByRoomId:(NSNumber *)roomId page:(int)page sender:(UIViewController <Alertable> *)sender;
- (NSMutableArray *)getEntryCommentListByEntryData:(EntryData *)entry sender:(UIViewController <Alertable> *)sender;
- (void)addEntryText:(NSString *)text roomId:(NSNumber *)roomId parentId:(NSNumber *)parentId sender:(UIViewController <Alertable> *)sender;
- (void)updateEntryText:(NSString *)text roomId:(NSNumber *)roomId entryId:(NSNumber *)entryId sender:(UIViewController <Alertable> *)sender;
- (void)deleteEntryByEntryId:(NSNumber *)entryId roomId:(NSNumber *)roomId sender:(UIViewController <Alertable> *)sender;
- (UIImage *)getAttachmentImageByEntryData:(EntryData *)entry sender:(UIViewController <Alertable> *)sender;
- (UIImage *)getRoomIconByRoomId:(NSNumber *)roomId;
- (UIImage *)getParticipationIconByRoomId:(NSNumber *)roomId participationId:(NSNumber *)participationId;
- (void)deleteCache;
@end
