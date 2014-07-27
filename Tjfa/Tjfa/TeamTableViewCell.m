//
//  TeamTableViewCell.m
//  Tjfa
//
//  Created by 邱峰 on 7/26/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TeamTableViewCell.h"
#import <UIImageView+AFNetworking.h>

@interface TeamTableViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView* emblemPath;
@property (nonatomic, weak) IBOutlet UILabel* name;
@property (nonatomic, weak) IBOutlet UILabel* goalCount;
@property (nonatomic, weak) IBOutlet UILabel* missCount;
@property (nonatomic, weak) IBOutlet UILabel* rank;
@property (nonatomic, weak) IBOutlet UILabel* group;
@end

@implementation TeamTableViewCell

- (void)setCellWithTeam:(Team*)team
{
    self.name.text = team.name;
    self.goalCount.text = [NSString stringWithFormat:@"进 %@", team.goalCount];
    self.missCount.text = [NSString stringWithFormat:@"失 %@", team.missCount];
    self.group.text = [NSString stringWithFormat:@"组 %@", team.groupNo];
    [self.emblemPath setImageWithURL:[NSURL URLWithString:team.emblemPath] placeholderImage:[UIImage imageNamed:@"qiufeng"]];
    int rank = [team.rank intValue];

    if (rank == 100) {
        self.rank.text = @"附加赛";
    } else if (rank == 0) {
        self.rank.text = @"小组赛";
    } else if (rank == 1) {
        self.rank.text = @"冠军";
    } else if (rank == 2) {
        self.rank.text = @"亚军";
    } else if (rank == 3) {
        self.rank.text = @"季军";
    } else {
        self.rank.text = [NSString stringWithFormat:@"%d 强", rank];
    }
}

@end
