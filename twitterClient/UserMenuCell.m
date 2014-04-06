//
//  UserMenuCell.m
//  twitterClient
//
//  Created by Eugenia Leong on 4/5/14.
//  Copyright (c) 2014 Eugenia Leong. All rights reserved.
//

#import "UserMenuCell.h"

@implementation UserMenuCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)didSelect:(id)sender
{
    [self.delegate sender:self didSelectUser:self.screenName.text];
}

@end
