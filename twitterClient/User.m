//
//  User.m
//  twitterClient
//
//  Created by Eugenia Leong on 3/29/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import "User.h"

NSString * const UserLogInNotification = @"UserLogInNotification";
NSString * const UserLogOutNotification = @"UserLogOutNotification";
NSString * const currentUserKey = @"current_user";

@interface User ()
@property (nonatomic, strong) NSDictionary *dictionary;
@end

@implementation User

static User *currentUser = nil;

- initWithDictionary:(NSDictionary *) dictionary {
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
    }
    NSLog(@"dictionary: %@ ", dictionary);
    return self;
}

+ (User *)currentUser {
    if (!currentUser) {
        NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:currentUserKey];
        if (userData != nil) {
            NSDictionary *userDictionary = [NSJSONSerialization JSONObjectWithData:userData options:NSJSONReadingMutableContainers error:nil];
            currentUser = [[User alloc] initWithDictionary:userDictionary];
        }
    }
    return currentUser;
}

+ (void)setCurrentUser:(User *)user {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (user != nil) {
        NSData *userData = [NSJSONSerialization dataWithJSONObject:user.dictionary options:NSJSONWritingPrettyPrinted error:nil];
        [defaults setObject:userData forKey:currentUserKey];
    } else {
        [defaults removeObjectForKey:currentUserKey];
        [[TwitterClient instance] removeAccessToken];
    }
    [defaults synchronize];
    
    if (!currentUser && user) {
        currentUser = user; // Needs to be set before firing the notification
        [[NSNotificationCenter defaultCenter] postNotificationName:UserLogInNotification object:nil];
    } else if (currentUser && !user) {
        currentUser = user; // Needs to be set before firing the notification
        [[NSNotificationCenter defaultCenter] postNotificationName:UserLogOutNotification object:nil];
    }
    
}

- (NSString *)name {
    return [self.dictionary valueForKeyPath:@"name"];
}

- (NSString *)profileImageUrl {
    NSString *url = [self.dictionary valueForKeyPath:@"profile_image_url"];
    return [url stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
}

- (NSString *)screenName {
    return [self.dictionary valueForKeyPath:@"screen_name"];
}

- (NSString *)backgroundImageUrl {
    return [self.dictionary valueForKeyPath:@"profile_background_image_url"];
}

- (NSInteger)followersCount {
    return [[self.dictionary valueForKey:@"followers_count"] integerValue];
}

- (NSInteger)friendsCount {
    //NSLog(@"friends count %@", [self.dictionary valueForKey:@"friends_count"]);
    return [[self.dictionary valueForKey:@"friends_count"] integerValue];
}

- (NSInteger)tweetCount {
    return [[self.dictionary valueForKey:@"statuses_count"] integerValue];
}


@end
