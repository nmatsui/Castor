//
//  GroupData.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RoomData : NSObject <NSCoding> {
    NSNumber *_roomId;
    NSString *_roomName;
    UIImage  *_roomIcon;
    BOOL     _opend;
    NSNumber *_toParam;
    NSString *_createdAt;
    NSString *_updatedAt;
    BOOL     _admin;
    NSNumber *_myId;
    NSMutableArray *_entries;
}

@property(nonatomic, retain) NSNumber *roomId;
@property(nonatomic, retain) NSString *roomName;
@property(nonatomic, retain) UIImage  *roomIcon;
@property(nonatomic, assign) BOOL     opend;
@property(nonatomic, retain) NSNumber *toParam;
@property(nonatomic, retain) NSString *createdAt;
@property(nonatomic, retain) NSString *updatedAt;
@property(nonatomic, assign) BOOL     admin;
@property(nonatomic, retain) NSNumber *myId;
@property(nonatomic, retain) NSMutableArray *entries;

@end
