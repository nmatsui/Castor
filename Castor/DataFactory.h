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

@interface DataFactory : NSObject {
    NSString *_authTokenPath;
    
    YouRoomGateway *_gateway;
}
@property(nonatomic, retain) NSString *authTokenPath;
@property(nonatomic, retain) YouRoomGateway *gateway;

- (BOOL)storeAuthTokenWithEmail:(NSString *)email password:(NSString *)password;
- (BOOL)hasAuthToken;
- (void)clearAuthToken;
- (NSMutableArray *)getGroupList;
- (NSMutableArray *)getRoomEntryListByRoomId:(NSNumber *)rId;
- (NSMutableArray *)getEntryCommentListByEntryId:(NSNumber *)eId;

@end
