//
//  TopScoreTableViewCell.m
//  Tjfa
//
//  Created by 邱峰 on 7/26/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TJTopScoreTableViewCell.h"
#import "Team.h"

@interface TJTopScoreTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *teamNameLable;
@property (nonatomic, weak) IBOutlet UILabel *scoreCount;

@end

@implementation TJTopScoreTableViewCell

- (void)setCellWithPlayer:(Player *)player
{
    self.nameLabel.text = player.name;
    self.teamNameLable.text = player.team.name;
    self.scoreCount.text = [NSString stringWithFormat:@"%@", player.goalCount];
}

@end
