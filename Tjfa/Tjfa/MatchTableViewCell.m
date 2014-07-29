//
//  MatchTableViewCell.m
//  Tjfa
//
//  Created by 邱峰 on 7/17/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "MatchTableViewCell.h"
#import "Team.h"
#import <UIImageView+AFNetworking.h>
#import "NSDate+Date2Str.h"

@interface MatchTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel* scoreA;
@property (weak, nonatomic) IBOutlet UILabel* scoreB;

@property (weak, nonatomic) IBOutlet UIImageView* emblemPathA;
@property (weak, nonatomic) IBOutlet UIImageView* emblemPathB;

@property (weak, nonatomic) IBOutlet UILabel* teamNameA;
@property (weak, nonatomic) IBOutlet UILabel* teamNameB;

@property (weak, nonatomic) IBOutlet UILabel* date;
@property (weak, nonatomic) IBOutlet UILabel* matchProperty;
@property (weak, nonatomic) IBOutlet UILabel* dateTime;
@property (weak, nonatomic) IBOutlet UILabel* isFinish;

@end

@implementation MatchTableViewCell

- (void)setCellWithMatch:(Match*)match
{
    self.scoreA.text = [NSString stringWithFormat:@"%@", match.scoreA];
    self.scoreB.text = [NSString stringWithFormat:@"%@", match.scoreB];
    self.teamNameA.text = match.teamA.name;
    self.teamNameB.text = match.teamB.name;
    self.date.text = [match.date date2str];
    int matchProperty = [match.matchProperty intValue];
    if (matchProperty == 0) {
        self.matchProperty.text = @"小组赛";
    } else if (matchProperty == 100) {
        self.matchProperty.text = @"附加赛";
    } else if (matchProperty == 1) {
        self.matchProperty.text = @"决赛";
    } else if (matchProperty == 2) {
        self.matchProperty.text = @"半决赛";
    } else {
        self.matchProperty.text = [NSString stringWithFormat:@"1/%d 决赛", matchProperty];
    }

    self.dateTime.text = [match.date date2CompetitionStr];
    if ([match.isStart intValue] == 0) {
        self.isFinish.text = @"未开始";
    } else {
        self.isFinish.text = @"已结束";
    }
    [self.emblemPathA setImageWithURL:[NSURL URLWithString:match.teamA.emblemPath] placeholderImage:[UIImage imageNamed:@"teamPlaceHolderA"]];
    [self.emblemPathB setImageWithURL:[NSURL URLWithString:match.teamB.emblemPath] placeholderImage:[UIImage imageNamed:@"teamPlaceHolderB"]];
}

@end
