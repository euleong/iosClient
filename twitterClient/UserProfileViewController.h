//
//  UserProfileViewController.h
//  twitterClient
//
//  Created by Eugenia Leong on 4/5/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserProfileViewController : UIViewController
- (id)initWithUser:(User *)user;
@end
