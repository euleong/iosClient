//
//  TweetCell.h
//  twitterClient
//
//  Created by Eugenia Leong on 3/30/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TweetCell;

@protocol TweetCellDelegate <NSObject>
@required
-(void)sender:(TweetCell *)sender imageTapped:(NSString *)screenName;
@end

@interface TweetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) id<TweetCellDelegate> delegate;

-(void)setValuesWithTweet:(id)tweet;

@end