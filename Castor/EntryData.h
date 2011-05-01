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
    NSString *participantName;
    NSString *content;
    NSNumber *level;
    UIImage  *participantIcon;
    NSString *attachmentType;
    NSString *attachmentText;
    UIImage  *attachmentImage;
}

@property(nonatomic, retain) NSNumber *entryId;
@property(nonatomic, retain) NSNumber *roomId;
@property(nonatomic, retain) NSString *participantName;
@property(nonatomic, retain) NSString *content;
@property(nonatomic, retain) NSNumber *level;
@property(nonatomic, retain) UIImage  *participantIcon;
@property(nonatomic, retain) NSString *attachmentType;
@property(nonatomic, retain) NSString *attachmentText;
@property(nonatomic, retain) UIImage  *attachmentImage;

@end
