//
//  TweetsViewController.h
//  twitterClient
//
//  Created by Eugenia Leong on 3/29/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetCell.h"

@interface TweetsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, TweetCellDelegate>
-(void) setMentions:(BOOL)value;
@end
