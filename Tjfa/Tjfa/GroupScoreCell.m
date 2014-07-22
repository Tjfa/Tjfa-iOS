//
//  GroupScoreCell.m
//  Tjfa
//
//  Created by 邱峰 on 7/22/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "GroupScoreCell.h"

@interface GroupScoreCell ()

@property (nonatomic, weak) IBOutlet UILabel* teamNameLabel;

@property (nonatomic, weak) IBOutlet UILabel* scoreLabel;

@property (nonatomic, weak) IBOutlet UILabel* goalCountLabel;

@property (nonatomic, weak) IBOutlet UILabel* missCountLabel;

@property (nonatomic, weak) IBOutlet UILabel* winCountLabel;

@end

@implementation GroupScoreCell

- (void)setCellWithTeam:(Team*)team
{
    self.teamNameLabel.text = team.name;
    self.scoreLabel.text = [NSString stringWithFormat:@"%@", team.score];
    self.goalCountLabel.text = [NSString stringWithFormat:@"%@", team.groupGoalCount];
    self.missCountLabel.text = [NSString stringWithFormat:@"%@", team.groupMissCount];
    self.winCountLabel.text = [NSString stringWithFormat:@"%d", [team.groupGoalCount intValue] - [team.groupMissCount intValue]];
}

@end
