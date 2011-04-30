//
//  GroupData.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GroupData : NSObject {
    NSNumber *roomId;
    NSString *roomName;
}

@property(nonatomic, retain) NSNumber *roomId;
@property(nonatomic, retain) NSString *roomName;

@end
