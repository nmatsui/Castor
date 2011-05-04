//
//  YouRoomGateway.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthCore.h"
#import "OAuth+Additions.h"


@interface YouRoomGateway : NSObject {
    
}
- (NSDictionary *)getAuthTokenWithEmail:(NSString *)email password:(NSString *)password;

@end

@interface YouRoomGateway (YouRoomGateway_ConsumerKey)

- (NSString *)getConsumerKey;
- (NSString *)getConsumerSecret;

@end