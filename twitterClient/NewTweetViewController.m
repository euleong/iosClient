//
//  NewTweetViewController.m
//  twitterClient
//
//  Created by Eugenia Leong on 3/30/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import "NewTweetViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"

UIBarButtonItem *tweetButton;

@interface NewTweetViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textArea;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@property (nonatomic,weak) NSDictionary *tweetData;

@end

@implementation NewTweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithExistingTweet:(NSDictionary *)tweetData {
    self = [super init];
    if (self) {
        self.tweetData = tweetData;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // add tweet button
    tweetButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet!" style:UIBarButtonItemStyleDone target:self action:@selector(onTweet:)];
    self.navigationItem.rightBarButtonItem = tweetButton;
    
    User *user = [User currentUser];
    self.name.text = [user name];
    self.screenName.text = [NSString stringWithFormat:@"@%@",[user screenName]];
    [self.profileImage setImageWithURL:[NSURL URLWithString:[user profileImageUrl]] placeholderImage:[UIImage imageNamed:self.name.text]];
    
    self.textArea.textContainer.lineFragmentPadding = 0;
    self.textArea.textContainerInset = UIEdgeInsetsZero;
    // replying to tweet
    if (self.tweetData != nil)
    {
        self.textArea.text = [NSString stringWithFormat:@"@%@ ", self.tweetData[@"user"][@"screen_name"]];
    }
    // composing a new tweet
    else {
        self.textArea.text = @"";
    }
    [self.textArea becomeFirstResponder];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onTweet:(id)sender {

    [[TwitterClient instance] tweet:self.textArea.text replyId:nil success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Tweeted!");
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure in tweeting");
    }];
}

@end
