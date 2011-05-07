//
//  DataFactory.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
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

- (BOOL)storeAuthTokenWithEmail:(NSString *)email password:(NSString *)password sender:(id)sender;
- (BOOL)hasAuthToken;
- (void)clearAuthToken;
- (NSMutableArray *)getRoomListWithSender:(id)sender;
- (NSMutableArray *)getRoomEntryListByRoomId:(NSNumber *)roomId page:(int)page sender:(id)sender;
- (NSMutableArray *)getEntryCommentListByEntryData:(EntryData *)entry sender:(id)sender;
- (void)addEntryText:(NSString *)text roomId:(NSNumber *)roomId parentId:(NSNumber *)parentId sender:(id)sender;
- (void)updateEntryText:(NSString *)text roomId:(NSNumber *)roomId entryId:(NSNumber *)entryId sender:(id)sender;
- (void)deleteEntryByEntryId:(NSNumber *)entryId roomId:(NSNumber *)roomId sender:(id)sender;
- (UIImage *)getAttachmentImageByEntryData:(EntryData *)entry sender:(id)sender;
- (void)deleteCache;
@end
