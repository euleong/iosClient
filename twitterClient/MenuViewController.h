//
//  MenuViewController.h
//  twitterClient
//
//  Created by Eugenia Leong on 4/5/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuViewController;

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
- (IBAction)onPan:(id)sender;

@end
