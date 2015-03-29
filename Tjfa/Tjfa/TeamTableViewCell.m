//
//  TeamTableViewCell.m
//  Tjfa
//
//  Created by 邱峰 on 7/26/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TeamTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

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
    [self.emblemPath sd_setImageWithURL:[NSURL URLWithString:team.emblemPath] placeholderImage:[UIImage imageNamed:@"teamPlaceHolderA"]];
    int rank = [team.rank intValue];

    if (rank == 100) {
        self.rank.text = @"附加赛";
    } else if (rank == 0) {
        self.rank.text = @"小组赛";
    } else if (rank == 1) {
        self.rank.text = @"冠 军";
    } else if (rank == 2) {
        self.rank.text = @"亚 军";
    } else if (rank == 3) {
        self.rank.text = @"季 军";
    } else {
        NSString* rankStr = [self getLetterWithNumber:rank];
        if (rankStr.length == 1) {
            self.rank.text = [NSString stringWithFormat:@"%@ 强", rankStr];
        } else {
            self.rank.text = [NSString stringWithFormat:@"%@强", rankStr];
        }
    }
}

- (NSString*)getLetterWithNumber:(int)rank
{
    if (rank == 0)
        return @"零";
    if (rank == 1)
        return @"一";
    if (rank == 2)
        return @"二";
    if (rank == 3)
        return @"三";
    if (rank == 4)
        return @"四";
    if (rank == 5)
        return @"五";
    if (rank == 6)
        return @"六";
    if (rank == 7)
        return @"七";
    if (rank == 8)
        return @"八";
    if (rank == 9)
        return @"九";
    if (rank == 10)
        return @"十";
    if (rank == 16)
        return @"十六";
    if (rank == 32)
        return @"三十二";
    if (rank == 64)
        return @"六十四";
    return [NSString stringWithFormat:@"%d", rank];
}

@end
