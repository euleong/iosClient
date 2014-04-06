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
        
        // user profile view
        self.userProfileViewController = [[UserProfileViewController alloc] initWithUser:[User currentUser]];
        self.userProfileNavigationController = [[UINavigationController alloc]
                                           initWithRootViewController:self.userProfileViewController];
        
        // home timeline view
        self.tweetsViewController = [[TweetsViewController alloc] init];
        self.tweetsNavigationController = [[UINavigationController alloc]
                                           initWithRootViewController:self.tweetsViewController];
        
        self.viewControllers = @[self.userProfileNavigationController, self.tweetsNavigationController, self.tweetsNavigationController];
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
    [self.mainContentView bringSubviewToFront:self.tweetsNavigationController.view];
    [self.view bringSubviewToFront:self.mainContentView];
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
    
    // get only mentions from tweets, find better way
    if (indexPath.row == 2) {
        [self.tweetsViewController setMentions:YES];
    }
    else {
        [self.tweetsViewController setMentions:NO];
    }
    
    UINavigationController *nvc = self.viewControllers[indexPath.row];
    [nvc.view removeFromSuperview];
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
