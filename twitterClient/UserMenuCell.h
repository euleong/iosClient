//
//  UserMenuCell.h
//  twitterClient
//
//  Created by Eugenia Leong on 4/5/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserMenuCell;

@protocol UserMenuCellDelegate <NSObject>
@optional
- (void)sender:(UserMenuCell *)sender didSelectUser:(NSString *)value;
@end

@interface UserMenuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) id<UserMenuCellDelegate> delegate;

@end
