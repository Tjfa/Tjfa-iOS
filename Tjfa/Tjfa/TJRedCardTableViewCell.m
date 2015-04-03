//
//  RedCardTableViewCell.m
//  Tjfa
//
//  Created by 邱峰 on 7/21/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TJRedCardTableViewCell.h"
#import "Team.h"

@interface TJRedCardTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
@property (nonatomic, weak) IBOutlet UILabel* teamNameLable;
@property (nonatomic, weak) IBOutlet UILabel* redCardCount;

@end

@implementation TJRedCardTableViewCell

- (void)setCellWithPlayer:(Player *)player
{
    self.nameLabel.text = player.name;
    self.teamNameLable.text = player.team.name;
    self.redCardCount.text = [NSString stringWithFormat:@"%@", player.redCard];
}

@end
