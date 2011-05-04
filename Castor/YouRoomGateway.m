//
//  YouRoomGateway.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/04.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YouRoomGateway.h"


@implementation YouRoomGateway

- (NSData *)request:(NSURL *)url method:(NSString *)method body:(NSData *)body oauth_token:(NSString *)oauth_token oauth_token_secret:(NSString *)oauth_token_secret {
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

- (NSDictionary *)getAuthTokenWithEmail:(NSString *)email password:(NSString *)password
{
    NSData *xauth_response = [self request:[NSURL URLWithString:@"https://www.youroom.in/oauth/access_token"]
                                    method:@"POST"
                                      body:[self getXAuthParamStringWithUsername:email password:password]
                               oauth_token:@""
                        oauth_token_secret:@""];
    NSDictionary *dict = [NSURL ab_parseURLQueryString:[[[NSString alloc] initWithData:xauth_response encoding:NSUTF8StringEncoding] autorelease]];
    if ([dict objectForKey:@"oauth_token"] == nil || [@"" isEqualToString:[dict objectForKey:@"oauth_token"]]
        || [dict objectForKey:@"oauth_token_secret"] == nil || [@"" isEqualToString:[dict objectForKey:@"oauth_token_secret"]]) {
        NSException* exception = [NSException exceptionWithName:@"OAuthException" reason:@"can't get token" userInfo:nil];
        [exception raise];
    }
    return dict;
}
@end
