//
//  YouRoomGateway.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YouRoomGateway.h"

@interface YouRoomGateway (Private)
- (NSData *)_request:(NSURL *)url method:(NSString *)method body:(NSData *)body oauth_token:(NSString *)oauth_token oauth_token_secret:(NSString *)oauth_token_secret;
- (NSData *)_getXAuthParamStringWithUsername:(NSString *)username password:(NSString *)password;
- (EntryData *)_constructEntryListFromJSONDic:(NSDictionary *)entry roomId:(NSNumber *)roomId level:(NSNumber *)level;
@end

@implementation YouRoomGateway

@synthesize oAuthToken = _oAuthToken;
@synthesize oAuthTokenSecret = _oAuthTokenSecret;

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
    [super dealloc];
}

- (NSDictionary *)retrieveAuthTokenWithEmail:(NSString *)email password:(NSString *)password
{
    NSLog(@"retrieveAuthToken");
    NSData *response = [self _request:[NSURL URLWithString:@"https://www.youroom.in/oauth/access_token"]
                               method:@"POST"
                                 body:[self _getXAuthParamStringWithUsername:email password:password]
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

- (NSMutableArray *)retrieveRoomList
{
    NSLog(@"retrieveRoomList");
    NSData *credentials = [self _request:[NSURL URLWithString:@"https://www.youroom.in/verify_credentials?format=json"]
                                  method:@"GET"
                                    body:Nil
                             oauth_token:self.oAuthToken
                      oauth_token_secret:self.oAuthTokenSecret];
    NSArray *pList = [[[[[[NSString alloc] initWithData:credentials encoding:NSUTF8StringEncoding] autorelease] JSONValue] objectForKey:@"user"] objectForKey:@"participations"];
    NSMutableDictionary *pDic = [[[NSMutableDictionary alloc] init] autorelease];
    for (NSDictionary *participation in pList) {
        NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
        [dic setObject:[participation objectForKey:@"admin"] forKey:@"admin"];
        [dic setObject:[participation objectForKey:@"id"] forKey:@"myId"];
        [pDic setObject:dic forKey:[[participation objectForKey:@"group"] objectForKey:@"id"]];
    }
    
    NSMutableArray *list = [[[NSMutableArray alloc] init] autorelease];
    NSData *response = [self _request:[NSURL URLWithString:@"https://www.youroom.in/groups/my?format=json"]
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
        roomData.admin     = [[[pDic objectForKey:roomData.roomId] objectForKey:@"admin"] boolValue];
        roomData.myId      = [[pDic objectForKey:roomData.roomId] objectForKey:@"myId"];
        roomData.roomIcon  = nil;
        [list addObject:roomData];
    }
    return list;
}

- (NSMutableArray *)retrieveEntryListByRoomId:(NSNumber *)roomId page:(int)page
{
    NSLog(@"retrieveEntryListByRoomId[%@] page[%d]", roomId, page);
    NSMutableArray *list = [[[NSMutableArray alloc] init] autorelease];
    NSData *response = [self _request:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.youroom.in/r/%@?format=json&page=%d", roomId, page]]
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
        [list addObject:[self _constructEntryListFromJSONDic:entry roomId:roomId level:[[NSNumber alloc] initWithInt:0]]];
    }
    return list;
}

- (NSMutableArray *)retrieveEntryCommentListByEntryId:(NSNumber *)entryId roomId:(NSNumber *)roomId
{
    NSLog(@"retrieveEntryCommentListByEntryId[%@] roomId[%@]", entryId, roomId);
    NSMutableArray *list = [[[NSMutableArray alloc] init] autorelease];
    NSData *response = [self _request:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.youroom.in/r/%@/entries/%@?format=json", roomId, entryId]]
                               method:@"GET"
                                 body:nil
                          oauth_token:self.oAuthToken
                   oauth_token_secret:self.oAuthTokenSecret];
    if (response == nil || [response length] == 0) {
        return list;
    }
    NSDictionary *entry = [[[[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease] JSONValue] objectForKey:@"entry"];
    [list addObject:[self _constructEntryListFromJSONDic:entry roomId:roomId level:[[NSNumber alloc] initWithInt:0]]];
    return list;
}

- (BOOL)postEntryText:(NSString *)text roomId:(NSNumber *)roomId parentId:(NSNumber *)parentId
{
    NSLog(@"postEntryText[%@] roomId[%@] parentId[%@]", text, roomId, parentId);
    NSString *body = [NSString stringWithFormat:@"entry[content]=%@", text];
    if (parentId != nil) {
        body = [body stringByAppendingFormat:@"&entry[parent_id]=%@", parentId]; 
    }
    NSData * response = [self _request:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.youroom.in/r/%@/entries?format=json", roomId]]
                                method:@"POST"
                                  body:[body dataUsingEncoding:NSUTF8StringEncoding]
                           oauth_token:self.oAuthToken
                    oauth_token_secret:self.oAuthTokenSecret];
    if (response == nil || [response length] == 0) {
        return NO; // ステータスコードまで見るべきか？
    }
    return YES;
}

- (BOOL)putEntryText:(NSString *)text roomId:(NSNumber *)roomId entryId:(NSNumber *)entryId
{
    NSLog(@"putEntryText[%@] roomId[%@] entryId[%@]", text, roomId, entryId);
    NSString *body = [NSString stringWithFormat:@"entry[content]=%@", text];
    NSData * response = [self _request:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.youroom.in/r/%@/entries/%@?format=json", roomId, entryId]]
                                method:@"PUT"
                                  body:[body dataUsingEncoding:NSUTF8StringEncoding]
                           oauth_token:self.oAuthToken
                    oauth_token_secret:self.oAuthTokenSecret];
    NSLog(@"%@", [[[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease] JSONValue]);
    if (response == nil || [response length] == 0) {
        return NO; // ステータスコードまで見るべきか？
    }
    return YES;
}

- (BOOL)deleteEntryByEntryId:(NSNumber *)entryId roomId:(NSNumber *)roomId
{
    NSLog(@"deleteEntryByEntryId[%@] roomId[%@]", entryId, roomId);
    //NSString *body = [NSString stringWithFormat:@"_method=delete"];
    NSData * response = [self _request:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.youroom.in/r/%@/entries/%@?format=json", roomId, entryId]]
                                method:@"DELETE"
                                  body:nil
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
    NSData *response = [self _request:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.youroom.in/r/%@/entries/%@/attachment", roomId, entryId]]
                               method:@"GET"
                                 body:nil
                          oauth_token:self.oAuthToken
                   oauth_token_secret:self.oAuthTokenSecret];
    if (response == nil || [response length] == 0) {
        return [[[UIImage alloc] init] autorelease];
    }
    return [[[UIImage alloc] initWithData:response] autorelease];
}

- (NSData *)retrieveRoomIconByRoomId:(NSNumber *)roomId
{
    NSLog(@"retrieveRoomIconByRoomId[%@]", roomId);
    NSData *response = [self _request:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.youroom.in/r/%@/picture", roomId]]
                               method:@"GET"
                                 body:nil
                          oauth_token:self.oAuthToken
                   oauth_token_secret:self.oAuthTokenSecret];
    if (response == nil || [response length] == 0) {
        return nil;
    }
    return response;
}

- (NSData *)retrieveParticipationIconByRoomId:(NSNumber *)roomId participationId:(NSNumber *)participationId
{
    NSLog(@"retrieveParticipationIconByRoomId[%@] participationId[%@]", roomId, participationId);
    NSData *response = [self _request:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.youroom.in/r/%@/participations/%@/picture", roomId, participationId]]
                               method:@"GET"
                                 body:nil
                          oauth_token:self.oAuthToken
                   oauth_token_secret:self.oAuthTokenSecret];
    if (response == nil || [response length] == 0) {
        return nil;
    }
    return response;
}

//// Private
- (NSData *)_request:(NSURL *)url method:(NSString *)method body:(NSData *)body oauth_token:(NSString *)oauth_token oauth_token_secret:(NSString *)oauth_token_secret
{
    NSLog(@"request(%@) to %@ [body:%@]", method, url, [[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding] autorelease]);
    NSString *header = OAuthorizationHeader(url, method, body, [self getConsumerKey], [self getConsumerSecret], oauth_token, oauth_token_secret);
//    NSLog(@"request header : %@", header);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:method];
    [request setValue:header forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:body];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //NSLog(@"statusCode : %d", [response statusCode]);
    //NSLog(@"raw response data : %@", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
    if (error != nil) {
        if ([@"Email/Password combination is not valid" isEqualToString:[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]]) {
            NSException* exception = [NSException exceptionWithName:@"AuthenticationException" 
                                                             reason:@"Email/Password combination is invalid" 
                                                           userInfo:nil];
            [exception raise];
        }
        else {
            NSException* exception = [NSException exceptionWithName:@"NetworkException" 
                                                             reason:@"network connection error" 
                                                           userInfo:nil];
            [exception raise];
        }
    }
    return data;
}

- (NSData *)_getXAuthParamStringWithUsername:(NSString *)username password:(NSString *)password
{
    return [[NSString stringWithFormat:@"x_auth_username=%@&x_auth_password=%@&x_auth_mode=client_auth", username, password] dataUsingEncoding:NSUTF8StringEncoding];
}

- (EntryData *)_constructEntryListFromJSONDic:(NSDictionary *)entry roomId:(NSNumber *)roomId level:(NSNumber *)level
{
    EntryData *entryData = [[[EntryData alloc] init] autorelease];
    entryData.roomId            = roomId;
    entryData.entryId           = [entry objectForKey:@"id"];
    entryData.content           = [[entry objectForKey:@"content"] isKindOfClass:[NSString class]] ? [entry objectForKey:@"content"] : nil;
    entryData.parentId          = [[entry objectForKey:@"parent_id"] isKindOfClass:[NSNumber class]] ? [entry objectForKey:@"parent_id"] : nil;
    entryData.rootId            = [[entry objectForKey:@"root_id"] isKindOfClass:[NSNumber class]] ? [entry objectForKey:@"root_id"] : nil;
    entryData.participationId   = [[entry objectForKey:@"participation"] objectForKey:@"id"];
    entryData.participationName = [[entry objectForKey:@"participation"] objectForKey:@"name"];
    entryData.participationIcon = nil;
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
    entryData.level             = level;
    if ([entry objectForKey:@"children"] != nil && [[entry objectForKey:@"children"] isKindOfClass:[NSArray class]]) {
        NSMutableArray *children = [[[NSMutableArray alloc] init] autorelease];
        for (NSDictionary *dic in [entry objectForKey:@"children"]) {
            [children addObject:[self _constructEntryListFromJSONDic:dic roomId:roomId level:[[NSNumber alloc] initWithInt:[level intValue]+1]]];
        }
        entryData.children      = children;
    }
    return entryData;
}

@end
