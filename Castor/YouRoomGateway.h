//
//  YouRoomGateway.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupData.h"
#import "EntryData.h"
#import "OAuthCore.h"
#import "OAuth+Additions.h"
#import "JSON.h"


@interface YouRoomGateway : NSObject {
    NSString *_oAuthToken;
    NSString *_oAuthTokenSecret;
}

@property(nonatomic, retain) NSString *oAuthToken;
@property(nonatomic, retain) NSString *oAuthTokenSecret;

- (id)initWithOAuthToken:(NSString *)oAuthToken oAuthTokenSecret:(NSString *)oAuthTokenSecret;
- (NSDictionary *)retrieveAuthTokenWithEmail:(NSString *)email password:(NSString *)password;
- (NSMutableArray *)retrieveGroupList;
- (NSMutableArray *)retrieveEntryListByRoomId:(NSNumber *)roomId page:(int)page;
- (NSMutableArray *)retrieveEntryCommentListByEntryId:(NSNumber *)entryId roomId:(NSNumber *)roomId;

@end

@interface YouRoomGateway (YouRoomGateway_ConsumerKey)

- (NSString *)getConsumerKey;
- (NSString *)getConsumerSecret;

@end