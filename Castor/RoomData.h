//
//  GroupData.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RoomData : NSObject {
    NSNumber *_roomId;
    NSString *_roomName;
    UIImage  *_roomIcon;
    BOOL     _opend;
    NSString *_toParam;
    NSString *_createdAt;
    NSString *_updatedAt;
}

@property(nonatomic, retain) NSNumber *roomId;
@property(nonatomic, retain) NSString *roomName;
@property(nonatomic, retain) UIImage  *roomIcon;
@property(nonatomic, assign) BOOL     opend;
@property(nonatomic, retain) NSString *toParam;
@property(nonatomic, retain) NSString *createdAt;
@property(nonatomic, retain) NSString *updatedAt;

@end
