//
//  MenuViewController.m
//  twitterClient
//
//  Created by Eugenia Leong on 4/5/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import "MenuViewController.h"
#import "UserMenuCell.h"
#import "MenuCell.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "TweetsViewController.h"
#import "UserProfileViewController.h"

@interface MenuViewController ()
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UIView *mainContentView;
@property (strong, nonatomic) TweetsViewController *tweetsViewController;
@property (nonatomic, strong) UINavigationController *tweetsNavigationController;
@property (strong, nonatomic) TweetsViewController *mentionsViewController;
@property (nonatomic, strong) UINavigationController *mentionsNavigationController;
@property (nonatomic, strong) UserProfileViewController *userProfileViewController;
@property (nonatomic, strong) UINavigationController *userProfileNavigationController;
@property (nonatomic, strong) NSArray *menuOptions;
@property (nonatomic, strong) NSArray *viewControllers;
@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.menuOptions = @[@"Profile", @"Home", @"Mentions"];
        UIColor *navigationBarColor = [UIColor colorWithRed:97/255.0 green:131/255.0 blue:188/255.0 alpha:1];
        
        // user profile view
        self.userProfileViewController = [[UserProfileViewController alloc] initWithUser:[User currentUser]];
        self.userProfileNavigationController = [[UINavigationController alloc]
                                           initWithRootViewController:self.userProfileViewController];
        self.userProfileNavigationController.navigationBar.barTintColor = navigationBarColor;
        
        // home timeline view
        self.tweetsViewController = [[TweetsViewController alloc] init];
        self.tweetsNavigationController = [[UINavigationController alloc]
                                           initWithRootViewController:self.tweetsViewController];
        self.tweetsNavigationController.navigationBar.barTintColor = navigationBarColor;
        
        self.mentionsViewController = [[TweetsViewController alloc] initWithMentions];
        self.mentionsNavigationController = [[UINavigationController alloc]
                                           initWithRootViewController:self.mentionsViewController];
        self.mentionsNavigationController.navigationBar.barTintColor = navigationBarColor;
        
        self.viewControllers = @[self.userProfileNavigationController, self.tweetsNavigationController, self.mentionsNavigationController];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.menuTableView.dataSource = self;
    self.menuTableView.delegate = self;
    self.menuTableView.scrollEnabled = NO;
    
    // register cells
    UINib *userMenuCellNib = [UINib nibWithNibName:@"UserMenuCell" bundle:nil];
    [self.menuTableView registerNib:userMenuCellNib forCellReuseIdentifier:@"UserMenuCell"];
    
    UINib *menuCellNib = [UINib nibWithNibName:@"MenuCell" bundle:nil];
    [self.menuTableView registerNib:menuCellNib forCellReuseIdentifier:@"MenuCell"];
    
    // main view
    // add tweets home timeline to the main view, which can be dragged away
    [self.mainContentView addSubview:self.tweetsNavigationController.view];
    [self.view bringSubviewToFront:self.mainContentView];
    
    self.navigationController.navigationBar.hidden = YES;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // display user profile cell
    if (indexPath.row == 0) {
        UserMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserMenuCell" forIndexPath:indexPath];
        User *user = [User currentUser];
        cell.name.text = [user name];
        cell.screenName.text = [NSString stringWithFormat:@"@%@",[user screenName]];
        [cell.profileImage setImageWithURL:[NSURL URLWithString:[user profileImageUrl]] placeholderImage:[UIImage imageNamed:cell.name.text]];

        return cell;
    }
    else if (indexPath.row < [self.menuOptions count]) {
        MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
        cell.menuLabel.text = self.menuOptions[indexPath.row];
        return cell;
    }
    
    return [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuOptions count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.menuTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // move main display view back
    [self displayMainContentView];
        
    UINavigationController *nvc = self.viewControllers[indexPath.row];
    [nvc popToRootViewControllerAnimated:NO];
    [self.mainContentView addSubview:nvc.view];
    [self.mainContentView bringSubviewToFront:nvc.view];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 130;
    }
    return 40;
}


- (IBAction)onPan:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    
    // drag the MAIN CONTENT VIEW frame away
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if (velocity.x > 0) {
            CGRect mainContentFrame = self.mainContentView.frame;
            if (mainContentFrame.origin.x <= self.view.frame.size.width-80) {
                mainContentFrame.origin.x += 10;
                self.mainContentView.frame = mainContentFrame;
            }
        }
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:0.5  animations:^{
            // show main content view
            if (velocity.x <= 0) {
                CGRect mainContentFrame = self.mainContentView.frame;
                mainContentFrame.origin.x = 0;
                self.mainContentView.frame = mainContentFrame;
            }
            // hide main content view
            else {
                CGRect mainContentFrame = self.mainContentView.frame;
                mainContentFrame.origin.x = mainContentFrame.size.width-80;
                self.mainContentView.frame = mainContentFrame;
                
            }
        }];
    }
}

- (void)displayMainContentView
{
    [UIView animateWithDuration:0.5  animations:^{
        CGRect mainContentFrame = self.mainContentView.frame;
        mainContentFrame.origin.x = 0;
        self.mainContentView.frame = mainContentFrame;
        
    }];
}

@end
