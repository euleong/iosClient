//
//  TweetDetailViewController.m
//  twitterClient
//
//  Created by Eugenia Leong on 3/30/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "NewTweetViewController.h"

@interface TweetDetailViewController ()
- (IBAction)onFavorite:(id)sender;
- (IBAction)onRetweet:(id)sender;
- (IBAction)onReply:(id)sender;

@property (weak, nonatomic) id tweet;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@end

@implementation TweetDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTweet:(Tweet *)tweet {
    self = [super init];
    
    if (self) {
        self.tweet = tweet;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.name.text = self.tweet[@"user"][@"name"];
    //self.name.text = self.tweet[@"user"][@"name"];
    self.screenName.text = [NSString stringWithFormat:@"@%@",self.tweet[@"user"][@"screen_name"]];
    self.tweetText.text = self.tweet[@"text"];
    [self.profileImage setImageWithURL:[NSURL URLWithString:self.tweet[@"user"][@"profile_image_url"]] placeholderImage:[UIImage imageNamed:self.name.text]];
    
    //self.tweet.favorited = [self.tweet.data[@"favorited"] boolValue];
    //self.tweet.retweeted = [self.tweet.data[@"retweeted"] boolValue];
    [self setFavoriteIcon];
    [self setRetweetIcon];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onFavorite:(id)sender {
    [[TwitterClient instance] favorite:self.tweet success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Favorited/Unfavorited!");
        //self.tweet.favorited = !self.tweet.favorited;
        [self setFavoriteIcon];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure in favoriting/unfavoriting");
    }];
}

- (IBAction)onRetweet:(id)sender {

    [[TwitterClient instance] retweetWithId:self.tweet[@"id"] success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Retweeted!");
        // retweeted = !retweeted;
        // api doesn't have un-retweet?
        //self.tweet.retweeted = true;
        [self setRetweetIcon];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Already retweeted or failure in retweeting");
    }];

}

- (IBAction)onReply:(id)sender {

    NewTweetViewController *newTweetViewController = [[NewTweetViewController alloc] initWithExistingTweet:self.tweet];
    [self.navigationController pushViewController:newTweetViewController animated:YES];
}

- (void)setFavoriteIcon{
    if ([self.tweet[@"favorited"] boolValue]) {
    //if (self.tweet.favorited) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateNormal];
    }
    else {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
    }
}

- (void)setRetweetIcon {
    if ([self.tweet[@"retweeted"] boolValue]) {
    //if (self.tweet.retweeted) {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateNormal];
    }
    else {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet"] forState:UIControlStateNormal];
    }
}
@end
