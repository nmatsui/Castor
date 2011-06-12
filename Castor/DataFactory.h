//
//  DataFactory.h
//  Castor
//
//  Copyright (C) 2011 Nobuyuki Matsui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractView.h"
#import "RoomData.h"
#import "EntryData.h"
#import "YouRoomGateway.h"
#import "CacheManager.h"

@class AbstractView;

@interface DataFactory : NSObject {
    NSString *_authTokenPath;
    YouRoomGateway *_gateway;
    CacheManager *_cacheManager;
}

@property(nonatomic, retain) NSString *authTokenPath;
@property(nonatomic, retain) YouRoomGateway *gateway;
@property(nonatomic, retain) CacheManager *cacheManager;

- (BOOL)storeAuthTokenWithEmail:(NSString *)email password:(NSString *)password sender:(AbstractView *)sender;
- (BOOL)hasAuthToken;
- (void)clearAuthToken;
- (NSMutableArray *)getHomeTimelineFromCache;
- (NSMutableArray *)getHomeTimelineWithPage:(int)page sender:(AbstractView *)sender;
- (NSMutableArray *)getRoomListFromCache;
- (NSMutableArray *)getRoomListWithSender:(AbstractView *)sender;
- (NSMutableArray *)getRoomEntryListFromCache:(NSNumber *)roomId;
- (NSMutableArray *)getRoomEntryListByRoomId:(NSNumber *)roomId page:(int)page sender:(AbstractView *)sender;
- (NSMutableArray *)getEntryCommentListFromCache:(EntryData *)entry;
- (NSMutableArray *)getEntryCommentListByEntryData:(EntryData *)entry sender:(AbstractView *)sender;
- (void)addEntryText:(NSString *)text roomId:(NSNumber *)roomId parentId:(NSNumber *)parentId sender:(AbstractView *)sender;
- (void)addEntryText:(NSString *)text image:(NSData *)image filename:(NSString *)filename roomId:(NSNumber *)roomId parentId:(NSNumber *)parentId sender:(AbstractView *)sender;
- (void)updateEntryText:(NSString *)text roomId:(NSNumber *)roomId entryId:(NSNumber *)entryId sender:(AbstractView *)sender;
- (void)deleteEntryByEntryId:(NSNumber *)entryId roomId:(NSNumber *)roomId sender:(AbstractView *)sender;
- (void)markEntryRead:(NSNumber *)entryId sender:(AbstractView *)sender;
- (UIImage *)getAttachmentImageByEntryData:(EntryData *)entry sender:(AbstractView *)sender;
- (UIImage *)getRoomIconByRoomId:(NSNumber *)roomId;
- (UIImage *)getParticipationIconByRoomId:(NSNumber *)roomId participationId:(NSNumber *)participationId;
- (void)deleteCache;

@end
