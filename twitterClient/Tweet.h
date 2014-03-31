//
//  Tweet.h
//  twitterClient
//
//  Created by Eugenia Leong on 3/30/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) BOOL retweeted;
@property (nonatomic, strong) NSDictionary *data;

//+ (NSMutableArray *)tweetsArray:(NSArray *)array;
@end
