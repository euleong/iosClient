//
//  TweetCell.m
//  twitterClient
//
//  Created by Eugenia Leong on 3/30/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "Tweet.h"
#import "UserProfileViewController.h"

@interface TweetCell()
- (void)imageTapped:(id)sender;
@end

@implementation TweetCell

- (void)awakeFromNib
{
    // Initialization code
    self.screenName.text = @"";
    self.name.text = @"";
    self.date.text = @"";
    self.tweetText.text     = @"";
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(imageTapped:)];
    
    [self.profileImage addGestureRecognizer:tapGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setValuesWithTweet:(Tweet *)tweet {

    self.screenName.text = [NSString stringWithFormat:@"@%@", tweet.data[@"user"][@"screen_name"]];
    
    self.name.text = tweet.data[@"user"][@"name"];
    
    self.tweetText.text = tweet.data[@"text"];
    
    NSString *originalImageURL = [tweet.data[@"user"][@"profile_image_url"] stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    [self.profileImage setImageWithURL:[NSURL URLWithString:originalImageURL] placeholderImage:[UIImage imageNamed:self.name.text]];
    
    self.date.text = [tweet relativeTime];//[self formatDateWithString:tweet.data[@"created_at"]];

}

-(void)imageTapped:(id)sender {
    [self.delegate sender:self imageTapped:self.screenName.text];
}

@end
