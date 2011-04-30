//
//  EntryData.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EntryData : NSObject {
    NSNumber *entryId;
    NSNumber *roomId;
    NSString *name;
    NSString *content;
}

@property(nonatomic, retain) NSNumber *entryId;
@property(nonatomic, retain) NSNumber *roomId;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *content;

@end
