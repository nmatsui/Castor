//
//  DataFactory.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupData.h"
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

- (BOOL)storeAuthTokenWithEmail:(NSString *)email password:(NSString *)password;
- (BOOL)hasAuthToken;
- (void)clearAuthToken;
- (NSMutableArray *)getGroupList;
- (NSMutableArray *)getRoomEntryListByRoomId:(NSNumber *)roomId page:(int)page;
- (NSMutableArray *)getEntryCommentListByEntryData:(EntryData *)entry;
- (void)sendEntryText:(NSString *)text roomId:(NSNumber *)roomId parentId:(NSNumber *)parentId;
- (UIImage *)getAttachmentImageByEntryData:(EntryData *)entry;
- (void)deleteCache;
@end
