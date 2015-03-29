//
//  RedCardTableViewCell.m
//  Tjfa
//
//  Created by 邱峰 on 7/21/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "RedCardTableViewCell.h"
#import "Team.h"

@interface RedCardTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
@property (nonatomic, weak) IBOutlet UILabel* teamNameLable;
@property (nonatomic, weak) IBOutlet UILabel* redCardCount;

@end

@implementation RedCardTableViewCell

- (void)setCellWithPlayer:(Player*)player
{
    NSLog(@"%@",player);
    NSLog(@"%@", player.name);
    self.nameLabel.text = player.name;
    self.teamNameLable.text = player.team.name;
    self.redCardCount.text = [NSString stringWithFormat:@"%@", player.redCard];
}

@end
