//
//  YellowCardTableViewCell.m
//  Tjfa
//
//  Created by 邱峰 on 7/26/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TJYellowCardTableViewCell.h"
#import "Team.h"

@interface TJYellowCardTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
@property (nonatomic, weak) IBOutlet UILabel* teamNameLable;
@property (nonatomic, weak) IBOutlet UILabel* yellowCardCount;

@end

@implementation TJYellowCardTableViewCell

- (void)setCellWithPlayer:(Player*)player
{
    self.nameLabel.text = player.name;
    self.teamNameLable.text = player.team.name;
    self.yellowCardCount.text = [NSString stringWithFormat:@"%@", player.yellowCard];
}

@end
