//
//  GroupScoreCell.m
//  Tjfa
//
//  Created by 邱峰 on 7/22/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TJGroupScoreCell.h"

@interface TJGroupScoreCell ()

@property (nonatomic, weak) IBOutlet UILabel* teamNameLabel;

@property (nonatomic, weak) IBOutlet UILabel* scoreLabel;

@property (nonatomic, weak) IBOutlet UILabel* goalCountLabel;

@property (nonatomic, weak) IBOutlet UILabel* winLostCount;

@property (nonatomic, weak) IBOutlet UILabel* winCountLabel;

@property (nonatomic, weak) IBOutlet UILabel* drawCountLable;
@property (nonatomic, weak) IBOutlet UILabel* lostCountLable;

@end

@implementation TJGroupScoreCell

- (void)setCellWithTeam:(Team*)team
{
    self.teamNameLabel.text = team.name;
    self.scoreLabel.text = [NSString stringWithFormat:@"%@", team.score];
    self.goalCountLabel.text = [NSString stringWithFormat:@"%@", team.groupGoalCount];
    self.winLostCount.text = [NSString stringWithFormat:@"%d", team.groupGoalCount.intValue - team.groupMissCount.intValue];
    self.winCountLabel.text = [NSString stringWithFormat:@"%@", team.groupWinCount];
    self.drawCountLable.text = [NSString stringWithFormat:@"%@", team.groupDrawCount];
    self.lostCountLable.text = [NSString stringWithFormat:@"%@", team.groupLostCount];
}

@end
