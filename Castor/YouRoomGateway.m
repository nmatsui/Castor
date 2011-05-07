//
//  YouRoomGateway.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YouRoomGateway.h"

@implementation YouRoomGateway

@synthesize oAuthToken = _oAuthToken;
@synthesize oAuthTokenSecret = _oAuthTokenSecret;
@synthesize cacheManager = _cacheManager;

- (id)initWithOAuthToken:(NSString *)oAuthToken oAuthTokenSecret:(NSString *)oAuthTokenSecret
{
    self = [super init];
    if (self) {
        self.oAuthToken = oAuthToken;
        self.oAuthTokenSecret = oAuthTokenSecret;
    }
    return self;
}

- (void)dealloc
{
    self.oAuthToken = nil;
    self.oAuthTokenSecret = nil;
    self.cacheManager = nil;
    [super dealloc];
}

- (NSData *)request:(NSURL *)url method:(NSString *)method body:(NSData *)body oauth_token:(NSString *)oauth_token oauth_token_secret:(NSString *)oauth_token_secret
{
    NSLog(@"request(%@) to %@ [body:%@]", method, url, [[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding] autorelease]);
    NSString *header = OAuthorizationHeader(url, method, body, [self getConsumerKey], [self getConsumerSecret], oauth_token, oauth_token_secret);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:method];
    [request setValue:header forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:body];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error != nil) {
        NSException* exception = [NSException exceptionWithName:@"OAuthException" reason:@"network disconnected" userInfo:nil];
        [exception raise];
    }
    return data;
}

- (NSData *)getXAuthParamStringWithUsername:(NSString *)username password:(NSString *)password
{
    return [[NSString stringWithFormat:@"x_auth_username=%@&x_auth_password=%@&x_auth_mode=client_auth", username, password] dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSDictionary *)retrieveAuthTokenWithEmail:(NSString *)email password:(NSString *)password
{
    NSLog(@"retrieveAuthToken");
    NSData *response = [self request:[NSURL URLWithString:@"https://www.youroom.in/oauth/access_token"]
                              method:@"POST"
                                body:[self getXAuthParamStringWithUsername:email password:password]
                         oauth_token:@""
                  oauth_token_secret:@""];
    NSDictionary *dict = [NSURL ab_parseURLQueryString:[[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease]];
    NSString *oAuthToken = [dict objectForKey:@"oauth_token"];
    NSString *oAuthTokenSecret = [dict objectForKey:@"oauth_token_secret"];
    if (oAuthToken == nil || [@"" isEqualToString:oAuthToken] || oAuthTokenSecret == nil || [@"" isEqualToString:oAuthTokenSecret]) {
        NSException* exception = [NSException exceptionWithName:@"OAuthException" reason:@"can't get oAuth token" userInfo:nil];
        [exception raise];
    }
    self.oAuthToken = oAuthToken;
    self.oAuthTokenSecret = oAuthTokenSecret;
    return dict;
}

- (NSData *)getRoomIconAtRoomId:(NSNumber *)roomId
{
    NSLog(@"getRoomIconAtRoomId[%@]", roomId);
    NSData *icon = [self.cacheManager selectRoomIconAtRoomId:roomId];
    if (icon == nil) {
        icon = [self request:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.youroom.in/r/%@/picture", roomId]]
                      method:@"GET"
                        body:nil
                 oauth_token:self.oAuthToken
          oauth_token_secret:self.oAuthTokenSecret];
        if (icon == nil || [icon length] == 0) {
            return nil;
        }
        [self.cacheManager insertOrReplaceRoomIconAtRoomId:roomId icon:icon];
    }
    return icon;
}

- (NSMutableArray *)retrieveRoomList
{
    NSLog(@"retrieveRoomList");
    NSMutableArray *list = [[[NSMutableArray alloc] init] autorelease];
    NSData *response = [self request:[NSURL URLWithString:@"https://www.youroom.in/groups/my?format=json"]
                              method:@"GET"
                                body:Nil
                         oauth_token:self.oAuthToken
                  oauth_token_secret:self.oAuthTokenSecret];
    if (response == nil || [response length] == 0) {
        return list;
    }
    NSArray *jsonArray = [[[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    for (NSDictionary *dic in jsonArray) {
        NSDictionary *group = [dic objectForKey:@"group"];
        RoomData *roomData = [[[RoomData alloc] init] autorelease];
        roomData.roomId    = [group objectForKey:@"id"];
        roomData.roomName  = [group objectForKey:@"name"];
        roomData.opend     = [[group objectForKey:@"opened"] boolValue];
        roomData.toParam   = [[group objectForKey:@"to_param"] isKindOfClass:[NSString class]] ? [group objectForKey:@"to_param"] : nil;
        roomData.createdAt = [group objectForKey:@"created_at"];
        roomData.updatedAt = [group objectForKey:@"updated_at"];
        roomData.roomIcon  = [[[UIImage alloc] initWithData:[self getRoomIconAtRoomId:roomData.roomId]] autorelease];
        [list addObject:roomData];
    }
    return list;
}

- (NSData *)getParticipationIconAtRoomId:(NSNumber *)roomId participationId:(NSNumber *)participationId
{
    NSLog(@"getParticipationIconAtRoomId[%@] participationId[%@]", roomId, participationId);
    NSData *icon = [self.cacheManager selectParticipationIconAtRoomId:roomId participationId:participationId];
    if (icon == nil) {
        icon = [self request:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.youroom.in/r/%@/participations/%@/picture", roomId, participationId]]
                      method:@"GET"
                        body:nil
                 oauth_token:self.oAuthToken
          oauth_token_secret:self.oAuthTokenSecret];
        if (icon == nil || [icon length] == 0) {
            return nil;
        }
        [self.cacheManager insertOrReplaceParticipationIconAtRoomId:roomId participationId:participationId icon:icon];
    }
    return icon;
}

- (EntryData *)constructEntryListFromJSONDic:(NSDictionary *)entry roomId:(NSNumber *)roomId level:(NSNumber *)level
{
    EntryData *entryData = [[[EntryData alloc] init] autorelease];
    entryData.roomId            = roomId;
    entryData.entryId           = [entry objectForKey:@"id"];
    entryData.content           = [[entry objectForKey:@"content"] isKindOfClass:[NSString class]] ? [entry objectForKey:@"content"] : nil;
    entryData.parentId          = [[entry objectForKey:@"parent_id"] isKindOfClass:[NSNumber class]] ? [entry objectForKey:@"parent_id"] : nil;
    entryData.rootId            = [[entry objectForKey:@"root_id"] isKindOfClass:[NSNumber class]] ? [entry objectForKey:@"root_id"] : nil;
    entryData.participationId   = [[entry objectForKey:@"participation"] objectForKey:@"id"];
    entryData.participationName = [[entry objectForKey:@"participation"] objectForKey:@"name"];
    if ([entry objectForKey:@"attachment"] != nil && [[entry objectForKey:@"attachment"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *attachment        = [entry objectForKey:@"attachment"];
        entryData.attachmentType        = [[attachment objectForKey:@"attachment_type"] isKindOfClass:[NSString class]] ? [attachment objectForKey:@"attachment_type"] : nil;
        entryData.attachmentContentType = [[attachment objectForKey:@"content_type"] isKindOfClass:[NSString class]] ? [attachment objectForKey:@"content_type"] : nil;
        if ([attachment objectForKey:@"data"] != nil && [[attachment objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *data          = [attachment objectForKey:@"data"];
            entryData.attachmentText    = [data objectForKey:@"text"];
            entryData.attachmentURL     = [data objectForKey:@"url"];
        }
        entryData.attachmentFilename    = [[attachment objectForKey:@"filename"] isKindOfClass:[NSString class]] ? [attachment objectForKey:@"filename"] : nil;
    }
    if ([entry objectForKey:@"descendants_count"] != nil && [[entry objectForKey:@"descendants_count"] isKindOfClass:[NSNumber class]]) {
        entryData.descendantsCount      = [entry objectForKey:@"descendants_count"];
    }
    entryData.createdAt         = [entry objectForKey:@"created_at"];
    entryData.updatedAt         = [entry objectForKey:@"updated_at"];
    entryData.participationIcon = [[[UIImage alloc] initWithData:[self getParticipationIconAtRoomId:roomId participationId:entryData.participationId]] autorelease];
    entryData.level             = level;
    if ([entry objectForKey:@"children"] != nil && [[entry objectForKey:@"children"] isKindOfClass:[NSArray class]]) {
        NSMutableArray *children = [[[NSMutableArray alloc] init] autorelease];
        for (NSDictionary *dic in [entry objectForKey:@"children"]) {
            [children addObject:[self constructEntryListFromJSONDic:dic roomId:roomId level:[[NSNumber alloc] initWithInt:[level intValue]+1]]];
        }
        entryData.children      = children;
    }
    return entryData;
}

- (NSMutableArray *)retrieveEntryListByRoomId:(NSNumber *)roomId page:(int)page
{
    NSLog(@"retrieveEntryListByRoomId[%@] page[%d]", roomId, page);
    NSMutableArray *list = [[[NSMutableArray alloc] init] autorelease];
    NSData *response = [self request:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.youroom.in/r/%@?format=json&page=%d", roomId, page]]
                              method:@"GET"
                                body:nil
                         oauth_token:self.oAuthToken
                  oauth_token_secret:self.oAuthTokenSecret];
    if (response == nil || [response length] == 0) {
        return list;
    }
    NSArray *jsonArray = [[[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    for (NSDictionary *dic in jsonArray) {
        NSDictionary *entry = [dic objectForKey:@"entry"];
        [list addObject:[self constructEntryListFromJSONDic:entry roomId:roomId level:[[NSNumber alloc] initWithInt:0]]];
    }
    return list;
}

- (NSMutableArray *)retrieveEntryCommentListByEntryId:(NSNumber *)entryId roomId:(NSNumber *)roomId
{
    NSLog(@"retrieveEntryCommentListByEntryId[%@] roomId[%@]", entryId, roomId);
    NSMutableArray *list = [[[NSMutableArray alloc] init] autorelease];
    NSData *response = [self request:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.youroom.in/r/%@/entries/%@?format=json", roomId, entryId]]
                              method:@"GET"
                                body:nil
                         oauth_token:self.oAuthToken
                  oauth_token_secret:self.oAuthTokenSecret];
    if (response == nil || [response length] == 0) {
        return list;
    }
    NSDictionary *entry = [[[[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease] JSONValue] objectForKey:@"entry"];
    [list addObject:[self constructEntryListFromJSONDic:entry roomId:roomId level:[[NSNumber alloc] initWithInt:0]]];
    return list;
}

- (BOOL)postEntryText:(NSString *)text roomId:(NSNumber *)roomId parentId:(NSNumber *)parentId
{
    NSLog(@"postEntryText[%@] roomId[%@] parentId[%@]", text, roomId, parentId);
    NSString *body = [NSString stringWithFormat:@"entry[content]=%@", text];
    if (parentId != nil) {
        body = [body stringByAppendingFormat:@"&entry[parent_id]=%@", parentId]; 
    }
    NSData * response = [self request:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.youroom.in/r/%@/entries?format=json", roomId]]
                               method:@"POST"
                                 body:[body dataUsingEncoding:NSUTF8StringEncoding]
                          oauth_token:self.oAuthToken
                   oauth_token_secret:self.oAuthTokenSecret];
    if (response == nil || [response length] == 0) {
        return NO; // ステータスコードまで見るべきか？
    }
    return YES;
}

- (UIImage *)retrieveEntryAttachmentImageByEntryId:(NSNumber *)entryId roomId:(NSNumber *)roomId
{
    NSLog(@"retrieveEntryAttachmentImageByEntryId[%@] roomId[%@]", entryId, roomId);
    NSData *response = [self request:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.youroom.in/r/%@/entries/%@/attachment", roomId, entryId]]
                              method:@"GET"
                                body:nil
                         oauth_token:self.oAuthToken
                  oauth_token_secret:self.oAuthTokenSecret];
    if (response == nil || [response length] == 0) {
        return [[[UIImage alloc] init] autorelease];
    }
    return [[[UIImage alloc] initWithData:response] autorelease];
}

@end
