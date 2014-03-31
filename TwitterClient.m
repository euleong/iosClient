//
//  TwitterClient.m
//  twitterClient
//
//  Created by Eugenia Leong on 3/29/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import "TwitterClient.h"
#import "User.h"

static NSString * const accessTokenKey = @"accessTokenKey";

@implementation TwitterClient

+ (TwitterClient *) instance {
    static TwitterClient *instance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com"] consumerKey:@"biYAqubJD0rK2cRatIQTZw" consumerSecret:@"2cygl2irBgMQVNuWJwMn6vXiyDnWtht7gSyuRnf0Fg"];
        
            //0Xn0MijIf8UTA9wFf4NPsLlZQ
            //IBDrfGP6YjCdK1Ssu8IWqP4tz9l5UMVDrGntYyAUbyC8ulz8nu
        
            //vg9yUnSBssFOF3Ypxte0YQrKe
            //6NqVw5NX7g8WTEjr3vvnEzLn5PlA5erEqF72vtgU94PxhI1w0H
        
            //biYAqubJD0rK2cRatIQTZw
            //2cygl2irBgMQVNuWJwMn6vXiyDnWtht7gSyuRnf0Fg
        
    });
    
    return instance;
}

- (void) login {
    
    if (self.isAuthorized) {
        [self currentUser];
    } else {
        [self.requestSerializer removeAccessToken];
        [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"eltwitter://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
            
            NSLog(@"Got the request token!");
            NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
            
        } failure:^(NSError *error) {
            NSLog(@"Failure getting the request token: %@", [error description]);
        }];
    }
}

- (void)tweet:(NSString *)tweetText replyId:(NSString *)replyStatusId success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"status": tweetText}];
    
    if (replyStatusId != nil) {
        [parameters setObject:replyStatusId forKey:@"in_reply_to_status_id"];
    }
    
    [self POST:@"1.1/statuses/update.json" parameters:parameters constructingBodyWithBlock:nil success:success failure:failure];
    
}

- (void)favorite:(Tweet *)tweet success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"id": tweet.data[@"id"]}];
    //if ([tweet[@"favorited"] boolValue])
    if (tweet.favorited)
    {
        [self POST:@"1.1/favorites/destroy.json" parameters:parameters success:success failure:failure];
    }
    else
    {
        [self POST:@"1.1/favorites/create.json" parameters:parameters success:success failure:failure];
    }
}

- (void)retweet:(Tweet *)tweet success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSString *id = tweet.data[@"id"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"id": id}];
    
    if (tweet.retweeted)
    {
        NSString *unRetweetPath = [NSString stringWithFormat:@"1.1/statuses/destroy/%@.json", id];
        [self POST:unRetweetPath parameters:parameters success:success failure:failure];
    }
    else
    {
        NSString *retweetPath = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", id];
        [self POST:retweetPath parameters:parameters success:success failure:failure];
    }

}

- (void) requestAccessTokenWithURL:(NSURL *)url {
   
    [self fetchAccessTokenWithPath:@"/oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
        
        NSLog(@"Got access token");
        [self.requestSerializer saveAccessToken:accessToken];
        [self setAccessToken:accessToken];
        [self currentUser];
        
    } failure:^(NSError *error) {
        NSLog(@"Failure getting the access token");
    }];
}

- (void)removeAccessToken {
    [self setAccessToken:nil];
}

- (void)setAccessToken:(BDBOAuthToken *)accessToken {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if (accessToken) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:accessToken];
        [defaults setObject:data forKey:accessTokenKey];
    } else {
        [defaults removeObjectForKey:accessTokenKey];
    }
    [defaults synchronize];
}

- (void)currentUser
{
    [self GET:@"1.1/account/verify_credentials.json"
   parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       [User setCurrentUser:[[User alloc] initWithDictionary:responseObject]];
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       NSLog(@"Failure verifying credentials %@", [error description]);
   }];
}

- (AFHTTPRequestOperation *) homeTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:success failure:failure];
}

@end
