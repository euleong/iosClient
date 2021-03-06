//
//  User.h
//  twitterClient
//
//  Created by Eugenia Leong on 3/29/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwitterClient.h"

extern NSString *const UserLogInNotification;
extern NSString *const UserLogOutNotification;

@interface User : NSObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *screenName;
@property (nonatomic, strong, readonly) NSString *profileImageUrl;
@property (nonatomic, strong, readonly) NSString *backgroundImageUrl;
@property (nonatomic, assign, readonly) NSInteger followersCount;
@property (nonatomic, assign, readonly) NSInteger friendsCount;
@property (nonatomic, assign, readonly) NSInteger tweetCount;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)user;

- (id)initWithDictionary:(NSDictionary *)data;

@end
