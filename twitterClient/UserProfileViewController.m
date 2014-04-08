//
//  UserProfileViewController.m
//  twitterClient
//
//  Created by Eugenia Leong on 4/5/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import "UserProfileViewController.h"
#import "UIImageView+AFNetworking.h"

@interface UserProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *followers;
@property (weak, nonatomic) IBOutlet UILabel *following;
@property (weak, nonatomic) IBOutlet UILabel *tweets;

@property (strong, nonatomic) User *user;

@end

@implementation UserProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUser:(User *)user
{
    self = [super init];
    if (self) {
        if (user.screenName == [User currentUser].screenName) {
            self.title = @"Me";
        }
        else {
            self.title = user.name;
        }

        self.user = user;
    }

     return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.title = @"Profile";
    
    [self.backgroundImage setImageWithURL:[NSURL URLWithString:[self.user backgroundImageUrl]] placeholderImage:[UIImage imageNamed:self.name.text]];
    
    [self.profileImage setImageWithURL:[NSURL URLWithString:[self.user profileImageUrl]] placeholderImage:[UIImage imageNamed:self.name.text]];
    self.screenName.text = [NSString stringWithFormat:@"@%@", self.user.screenName];
    self.name.text = self.user.name;
    
    self.followers.text = [NSString stringWithFormat:@"%d", (int)self.user.followersCount];
    self.following.text = [NSString stringWithFormat:@"%d", (int)self.user.friendsCount];
    self.tweets.text = [NSString stringWithFormat:@"%d", (int)self.user.tweetCount];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
