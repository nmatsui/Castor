//
//  DataFactory.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataFactory.h"


@implementation DataFactory

@synthesize authTokenPath = _authTokenPath;
@synthesize gateway = _gateway;

- (id)init
{
    self = [super init];
    if(self){
        self.authTokenPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"oauth_token"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.authTokenPath]) {
            NSData *data = [[[NSData alloc] initWithContentsOfFile:self.authTokenPath] autorelease];
            NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            NSLog(@"find token from cache %@:%@", [dict objectForKey:@"oauth_token"], [dict objectForKey:@"oauth_token_secret"]);
            self.gateway = [[YouRoomGateway alloc] initWithOAuthToken:[dict objectForKey:@"oauth_token"] oAuthTokenSecret:[dict objectForKey:@"oauth_token_secret"]];
        }
        else {
            NSLog(@"can't find token from cache");
            self.gateway = [[YouRoomGateway alloc] init];
        }
    }
    return self;
}

- (BOOL)storeAuthTokenWithEmail:(NSString *)email password:(NSString *)password
{
    BOOL result = YES;
    @try {
        [self clearAuthToken];
        NSDictionary *dict = [self.gateway retrieveAuthTokenWithEmail:email password:password];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
        [data writeToFile:self.authTokenPath atomically:YES];
        NSLog(@"store token to cache %@:%@", [dict objectForKey:@"oauth_token"], [dict objectForKey:@"oauth_token_secret"]);
    }
    @catch (...) {
        result = NO;
    }
    return result;
}

- (BOOL)hasAuthToken
{
    return [[NSFileManager defaultManager] fileExistsAtPath:self.authTokenPath];
}

- (void)clearAuthToken
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.authTokenPath]) [[NSFileManager defaultManager] removeItemAtPath:self.authTokenPath error:nil];
}

- (NSMutableArray *)getGroupList
{
    NSLog(@"getGroupList");
    NSMutableArray *list;
    @try {
        list = [self.gateway retrieveGroupList];
    }
    @catch (...) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" 
                                                  message:@"Network Disconnected" 
                                                  delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
//    list = [[[NSMutableArray alloc] init] autorelease];
//    for (int i = 0; i < 20; i++) {
//        GroupData *groupData = [[[GroupData alloc] init] autorelease];
//        groupData.roomId = [[NSNumber alloc] initWithInt:i];
//        groupData.roomName = [NSString stringWithFormat:@"%d room",i];
//        groupData.roomIcon = [UIImage imageNamed:@"myrooms.png"];
//        [list addObject:groupData];
//    }
    return list;
}

- (NSMutableArray *)getRoomEntryListByRoomId:(NSNumber *)rId
{
    NSMutableArray *list = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < 20; i++) {
        EntryData *entryData = [[[EntryData alloc] init] autorelease];
        entryData.entryId = [[NSNumber alloc] initWithInt:i];
        entryData.roomId = rId;
        entryData.participantName = @"ほげほげ";
        entryData.level = [[NSNumber alloc] initWithInt:0];
        entryData.participantIcon = [UIImage imageNamed:@"myrooms.png"];
        NSString *str = [NSString stringWithFormat:@"[%d] %d entry",[rId intValue], i];
        for (int j = 0; j < i; j++) {
            str = [str stringByAppendingString:@"あいうえおかきくけこ"];
        }
        if (i%5==0) {
            entryData.attachmentType = @"Text";
            entryData.attachmentText = @"youRoom(ユールーム)は、グループでの情報共有をシンプルに実現できるツールです。友人同士の気軽なコミュニケーションや、企業を超えたプロジェクトでのコラボレーションといった用途で、安全に閉じられた安心感の中で、短いメッセージを共有することができます。";
            str = [str stringByAppendingFormat:@"\n<Text attached>"];
        }
        else if (i%7==0) {
            entryData.attachmentType = @"Image";
            entryData.attachmentImage = [UIImage imageNamed:@"test.jpg"];
            str = [str stringByAppendingFormat:@"\n<Image attached>"];
        }
        else if (i%9==0) {
            entryData.attachmentType = @"File";
            str = [str stringByAppendingFormat:@"\n<File attached>"];
        }
        entryData.content = str;
        [list addObject:entryData];
    }
    return list;
}

- (NSMutableArray *)getEntryCommentListByEntryId:(NSNumber *)eId
{
    NSMutableArray *list = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < 20; i++) {
        EntryData *entryData = [[[EntryData alloc] init] autorelease];
        entryData.entryId = [[NSNumber alloc] initWithInt:i];
        entryData.participantName = @"こめんと";
        entryData.level = [[NSNumber alloc] initWithInt:i%5+1];
        entryData.participantIcon = [UIImage imageNamed:@"myrooms.png"];
        NSString *str = [NSString stringWithFormat:@"[%d] %d comment",[eId intValue], i];
        for (int j = 0; j < i; j++) {
            str = [str stringByAppendingString:@"アイウエオカキクケコ"];
        }
        entryData.content = str;
        [list addObject:entryData];
    }
    return list;
}

- (void)dealloc
{
    self.authTokenPath = nil;
    self.gateway = nil;
    [super dealloc];
}
@end
