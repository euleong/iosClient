//
//  Tweet.m
//  twitterClient
//
//  Created by Eugenia Leong on 3/30/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

+ (NSMutableArray *)tweetsArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *params in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:params]];
    }
    return tweets;
}

- initWithDictionary:(NSDictionary *) dictionary {
    self = [super init];
    if (self) {
        self.data = dictionary;
    }
    return self;
}

//-(NSString *) formatDateWithString:(NSString *)createdAt {
-(NSString *)relativeTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    NSDate *date = [dateFormatter dateFromString:self.data[@"created_at"]];
    NSDate *now = [NSDate date];
    double interval = [date timeIntervalSinceDate:now];
    NSString *dateString;
    interval = interval * -1;
    if (interval < 1) {
    	dateString = @"just now";
    } else 	if (interval < 60) {
    	dateString = @"1m";
    } else if (interval < 3600) {
    	int diff = round(interval / 60);
    	dateString = [NSString stringWithFormat:@"%dm", diff];
    } else if (interval < 86400) {
    	int diff = round(interval / 60 / 60);
    	dateString = [NSString stringWithFormat:@"%dh", diff];
    } else if (interval < 2629743) {
    	int diff = round(interval / 60 / 60 / 24);
    	dateString = [NSString stringWithFormat:@"%d days ago", diff];
    } else {
    	dateString = @"unknown";
    }
    
    return dateString;
}

-(NSString *)absoluteDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    NSDate *date = [dateFormatter dateFromString:self.data[@"created_at"]];
    
    return [NSDateFormatter localizedStringFromDate:date
                                   dateStyle:NSDateFormatterMediumStyle
                                   timeStyle:NSDateFormatterShortStyle];

}

@end
