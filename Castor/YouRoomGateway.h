//
//  YouRoomGateway.h
//  Castor
//
//  Copyright (C) 2011 Nobuyuki Matsui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomData.h"
#import "EntryData.h"
#import "OAuthCore.h"
#import "OAuth+Additions.h"
#import "JSON.h"
#import "RegexKitLite.h"
#import "RKLMatchEnumerator.h"


@interface YouRoomGateway : NSObject {
    NSString *_oAuthToken;
    NSString *_oAuthTokenSecret;
    NSMutableDictionary *_pDic;
}

@property(nonatomic, retain) NSString *oAuthToken;
@property(nonatomic, retain) NSString *oAuthTokenSecret;
@property(nonatomic, retain) NSMutableDictionary *pDic;

- (id)initWithOAuthToken:(NSString *)oAuthToken oAuthTokenSecret:(NSString *)oAuthTokenSecret;
- (NSDictionary *)retrieveAuthTokenWithEmail:(NSString *)email password:(NSString *)password;
- (NSMutableArray *)retrieveHomeTimelineWithPage:(int)page;
- (NSMutableArray *)retrieveRoomList;
- (NSMutableArray *)retrieveEntryListByRoomId:(NSNumber *)roomId page:(int)page;
- (NSMutableArray *)retrieveEntryCommentListByEntryId:(NSNumber *)entryId roomId:(NSNumber *)roomId;
- (BOOL)postEntryText:(NSString *)text roomId:(NSNumber *)roomId parentId:(NSNumber *)parentId;
- (BOOL)postEntryText:(NSString *)text image:(NSData *)image filename:(NSString *)filename roomId:(NSNumber *)roomId parentId:(NSNumber *)parentId;
- (BOOL)putEntryText:(NSString *)text roomId:(NSNumber *)roomId entryId:(NSNumber *)entryId;
- (BOOL)deleteEntryByEntryId:(NSNumber *)entryId roomId:(NSNumber *)roomId;
- (UIImage *)retrieveEntryAttachmentImageByEntryId:(NSNumber *)entryId roomId:(NSNumber *)roomId;
- (NSData *)retrieveRoomIconByRoomId:(NSNumber *)roomId;
- (NSData *)retrieveParticipationIconByRoomId:(NSNumber *)roomId participationId:(NSNumber *)participationId;
- (BOOL)markRead:(NSNumber *)entryId;

@end

@interface YouRoomGateway (YouRoomGateway_ConsumerKey)
- (NSString *)getConsumerKey;
- (NSString *)getConsumerSecret;
@end