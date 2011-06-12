//
//  GroupData.h
//  Castor
//
//  Copyright (C) 2011 Nobuyuki Matsui. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RoomData : NSObject <NSCoding> {
    NSNumber *_roomId;
    NSString *_roomName;
    UIImage  *_roomIcon;
    BOOL     _opend;
    NSString *_toParam;
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
@property(nonatomic, retain) NSString *toParam;
@property(nonatomic, retain) NSString *createdAt;
@property(nonatomic, retain) NSString *updatedAt;
@property(nonatomic, assign) BOOL     admin;
@property(nonatomic, retain) NSNumber *myId;
@property(nonatomic, retain) NSMutableArray *entries;

@end
