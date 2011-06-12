//
//  EntryData.h
//  Castor
//
//  Copyright (C) 2011 Nobuyuki Matsui. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EntryData : NSObject <NSCoding> {
    NSNumber       *_entryId;
    NSNumber       *_roomId;
    NSString       *_roomName;
    NSString       *_content;
    NSNumber       *_parentId;
    NSNumber       *_rootId;
    NSNumber       *_participationId;
    NSString       *_participationName;
    UIImage        *_participationIcon;
    NSString       *_attachmentType;
    NSString       *_attachmentContentType;
    NSString       *_attachmentText;
    NSString       *_attachmentURL;
    NSString       *_attachmentFilename;
    NSMutableArray *_children;
    NSNumber       *_descendantsCount;
    NSString       *_createdAt;
    NSString       *_updatedAt;
    NSNumber       *_level;
    NSMutableArray *_urlList;
}

@property(nonatomic, retain) NSNumber       *entryId;
@property(nonatomic, retain) NSNumber       *roomId;
@property(nonatomic, retain) NSString       *roomName;
@property(nonatomic, retain) NSString       *content;
@property(nonatomic, retain) NSNumber       *parentId;
@property(nonatomic, retain) NSNumber       *rootId;
@property(nonatomic, retain) NSNumber       *participationId;
@property(nonatomic, retain) NSString       *participationName;
@property(nonatomic, retain) UIImage        *participationIcon;
@property(nonatomic, retain) NSString       *attachmentType;
@property(nonatomic, retain) NSString       *attachmentContentType;
@property(nonatomic, retain) NSString       *attachmentText;
@property(nonatomic, retain) NSString       *attachmentURL;
@property(nonatomic, retain) NSString       *attachmentFilename;
@property(nonatomic, retain) NSMutableArray *children;
@property(nonatomic, retain) NSNumber       *descendantsCount;
@property(nonatomic, retain) NSString       *createdAt;
@property(nonatomic, retain) NSString       *updatedAt;
@property(nonatomic, retain) NSNumber       *level;
@property(nonatomic, retain) NSMutableArray *urlList;

@end
