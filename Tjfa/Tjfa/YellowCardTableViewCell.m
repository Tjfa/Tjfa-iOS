//
//  YellowCardTableViewCell.m
//  Tjfa
//
//  Created by 邱峰 on 7/26/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "YellowCardTableViewCell.h"
#import "Team.h"

@interface YellowCardTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
@property (nonatomic, weak) IBOutlet UILabel* teamNameLable;
@property (nonatomic, weak) IBOutlet UILabel* yellowCardCount;

@end

@implementation YellowCardTableViewCell

- (void)setCellWithPlayer:(Player*)player
{
    self.nameLabel.text = player.name;
    self.teamNameLable.text = player.team.name;
    self.yellowCardCount.text = [NSString stringWithFormat:@"%@", player.yellowCard];
}

@end
