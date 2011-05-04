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

- (id)initWithOAuthToken:(NSString *)oAuthToken oAuthTokenSecret:(NSString *)oAuthTokenSecret
{
    self = [super init];
    if (self) {
        self.oAuthToken = oAuthToken;
        self.oAuthTokenSecret = oAuthTokenSecret;
    }
    return self;
}

- (NSData *)request:(NSURL *)url method:(NSString *)method body:(NSData *)body oauth_token:(NSString *)oauth_token oauth_token_secret:(NSString *)oauth_token_secret {
    NSLog(@"request(%@) to %@ [body:%@]", method, url, [[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding] autorelease]);
    NSString *header = OAuthorizationHeader(url, method, body, [self getConsumerKey], [self getConsumerSecret], oauth_token, oauth_token_secret);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:method];
    [request setValue:header forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:body];
    NSURLResponse *response = nil;
    NSError       *error    = nil;
    return [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
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
        NSException* exception = [NSException exceptionWithName:@"OAuthException" reason:@"can't get token" userInfo:nil];
        [exception raise];
    }
    self.oAuthToken = oAuthToken;
    self.oAuthTokenSecret = oAuthTokenSecret;
    return dict;
}

- (NSMutableArray *)retrieveGroupList
{
    NSLog(@"retrieveGroupList");
    NSMutableArray *list = [[[NSMutableArray alloc] init] autorelease];
    NSData *response = [self request:[NSURL URLWithString:@"https://www.youroom.in/groups/my?format=json"]
                              method:@"GET"
                                body:Nil
                         oauth_token:self.oAuthToken
                  oauth_token_secret:self.oAuthTokenSecret];
    NSArray *jsonArry = [[[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    for (NSDictionary *dic in jsonArry) {
        NSDictionary *group = [dic objectForKey:@"group"];
        GroupData *groupData = [[[GroupData alloc] init] autorelease];
        groupData.roomId = [[NSNumber alloc] initWithInt:[[group objectForKey:@"id"] intValue]];
        groupData.roomName = [group objectForKey:@"name"];
        NSData *response = [self request:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.youroom.in/r/%@/picture", groupData.roomId]]
                                  method:@"GET"
                                    body:Nil
                            oauth_token:self.oAuthToken
                      oauth_token_secret:self.oAuthTokenSecret];
        groupData.roomIcon = [[[UIImage alloc] initWithData:response] autorelease];
        [list addObject:groupData];
    }
    return list;
}

@end
