//
//  TwitterClient.h
//  twitterClient
//
//  Created by Eugenia Leong on 3/29/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDBOAuth1RequestOperationManager.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *) instance;

- (void) login;

- (void) removeAccessToken;

- (void) requestAccessTokenWithURL:(NSURL *)url;

- (AFHTTPRequestOperation *) homeTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)tweet:(NSString *)tweetText replyId:(NSString *)replyStatusId success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)favorite:(id)tweet success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)retweetWithId:(NSString *)id success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end