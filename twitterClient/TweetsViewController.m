//
//  TweetsViewController.m
//  twitterClient
//
//  Created by Eugenia Leong on 3/29/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import "TweetsViewController.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "NewTweetViewController.h"
#import "TweetDetailViewController.h"
#import "User.h"
#import "Tweet.h"

NSString * const CELL_IDENTIFIER = @"TweetCell";
NSInteger const TEXT_LABEL_WIDTH = 230;
NSInteger const CELL_HEIGHT_EXTRA = 70;

UIBarButtonItem *signOutButton;
UIBarButtonItem *newTweetButton;
NSMutableArray * tweets;

@interface TweetsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tweetsTableView;
@property (weak, nonatomic) NSMutableArray * tweets;

@end

@implementation TweetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Home";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tweetsTableView.dataSource = self;
    self.tweetsTableView.delegate = self;
    
    UINib *customNib = [UINib nibWithNibName:CELL_IDENTIFIER bundle:nil];
    [self.tweetsTableView registerNib:customNib forCellReuseIdentifier:CELL_IDENTIFIER];
    
    // add signout button
    signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStyleDone target:self action:@selector(onSignout:)];
    [signOutButton setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = signOutButton;
    
    // add new tweet button
    newTweetButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onNew:)];
    [newTweetButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = newTweetButton;
    
    // enable pull to refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Release to refresh"];
    [self.tweetsTableView addSubview:refreshControl];

}

- (void)viewDidAppear:(BOOL)animated {

    // get tweets
    [self homeTimeline];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    Tweet * tweet = tweets[indexPath.row];
    
    if (tweet) {
        [cell setValuesWithTweet:tweet];        
    }

    
    return cell;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tweet * tweet = tweets[indexPath.row];
    NSString* text = [NSString stringWithFormat:@"%@",tweet.data[@"text"]];
    UIFont *font = [UIFont boldSystemFontOfSize: 11];
    CGRect rect = [text boundingRectWithSize:CGSizeMake(TEXT_LABEL_WIDTH, MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName: font} context:nil];
    return rect.size.height + CELL_HEIGHT_EXTRA;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tweetsTableView deselectRowAtIndexPath:indexPath animated:YES];

    Tweet *tweet = tweets[indexPath.row];
    TweetDetailViewController *tweetDetailViewController = [[TweetDetailViewController alloc] initWithTweet:tweet];
    
    [self.navigationController pushViewController:tweetDetailViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)onNew:(id)sender
{
    NewTweetViewController *ntvc = [[NewTweetViewController alloc] initWithNibName:@"NewTweetViewController" bundle:nil];
    
    [[self navigationController] pushViewController:ntvc animated:YES];
}


-(IBAction)onSignout:(id)sender
{
    [User setCurrentUser:nil];
}

-(void)homeTimeline{
    [[TwitterClient instance] homeTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"response: %@", responseObject);
        //tweets = responseObject;
        tweets = [Tweet tweetsArray:responseObject];
        //NSLog(@"tweets: %@", tweets);
        [self.tweetsTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure getting tweets");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure:" message:@"Could not get tweets!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }];

}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self homeTimeline];
    [refreshControl endRefreshing];
}

@end
