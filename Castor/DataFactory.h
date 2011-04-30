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

@interface DataFactory : NSObject {
    
}

- (NSMutableArray *)getGroupList;
- (NSMutableArray *)getRoomEntryListByRoomId:(NSNumber *)rId;
- (NSMutableArray *)getEntryCommentListByEntryId:(NSNumber *)eId;

@end
