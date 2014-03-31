//
//  NewTweetViewController.h
//  twitterClient
//
//  Created by Eugenia Leong on 3/30/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface NewTweetViewController : UIViewController
- (id)initWithExistingTweet:(NSDictionary *)tweetData;

@end
