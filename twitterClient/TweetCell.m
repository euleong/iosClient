//
//  TweetCell.m
//  twitterClient
//
//  Created by Eugenia Leong on 3/30/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"

@implementation TweetCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setValuesWithTweet:(id)tweet {

    self.screenName.text = [NSString stringWithFormat:@"@%@", tweet[@"user"][@"screen_name"]];
    
    self.name.text = tweet[@"user"][@"name"];
    
    self.tweetText.text = tweet[@"text"];
    
    [self.profileImage setImageWithURL:[NSURL URLWithString:tweet[@"user"][@"profile_image_url"]] placeholderImage:[UIImage imageNamed:self.name.text]];
    
    self.date.text = [self formatDateWithString:tweet[@"created_at"]];

}

-(NSString *) formatDateWithString:(NSString *)createdAt {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    NSDate *date = [dateFormatter dateFromString:createdAt];
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

@end
