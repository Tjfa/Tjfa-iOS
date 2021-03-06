//
//  MatchTableViewCell.m
//  Tjfa
//
//  Created by 邱峰 on 7/17/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TJMatchTableViewCell.h"
#import "Team.h"
#import <UIImageView+AFNetworking.h>
#import "NSDate+Date2Str.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TJMatchTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *scoreA;
@property (weak, nonatomic) IBOutlet UILabel *scoreB;

@property (weak, nonatomic) IBOutlet UIImageView *emblemPathA;
@property (weak, nonatomic) IBOutlet UIImageView *emblemPathB;

@property (weak, nonatomic) IBOutlet UILabel *teamNameA;
@property (weak, nonatomic) IBOutlet UILabel *teamNameB;

@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *matchProperty;
@property (weak, nonatomic) IBOutlet UILabel *dateTime;
@property (weak, nonatomic) IBOutlet UILabel *isFinish;
@property (weak, nonatomic) IBOutlet UILabel *penaltyA;
@property (weak, nonatomic) IBOutlet UILabel *penaltyB;

@end

@implementation TJMatchTableViewCell

- (void)setCellWithMatch:(Match *)match
{
    self.scoreA.text = [NSString stringWithFormat:@"%@", match.scoreA];
    self.scoreB.text = [NSString stringWithFormat:@"%@", match.scoreB];
    self.teamNameA.text = match.teamA.name;
    self.teamNameB.text = match.teamB.name;
    NSString *dateStr = [match.date date2str];
    NSInteger index = [dateStr rangeOfString:@" "].location;
    self.date.text = [dateStr substringToIndex:index];
    self.dateTime.text = [dateStr substringFromIndex:index + 1];
    int matchProperty = [match.matchProperty intValue];
    if (matchProperty == 0) {
        self.matchProperty.text = @"小组赛";
    }
    else if (matchProperty == 100) {
        self.matchProperty.text = @"附加赛";
    }
    else if (matchProperty == 1) {
        self.matchProperty.text = @"决赛";
    }
    else if (matchProperty == 2) {
        self.matchProperty.text = @"半决赛";
    }
    else if (matchProperty == 3) {
        self.matchProperty.text = @"三四名";
    }
    else {
        self.matchProperty.text = [NSString stringWithFormat:@"1/%d 决赛", matchProperty];
    }

    if (match.hint && ![match.hint isEqualToString:@""]) {
        self.isFinish.font = [UIFont systemFontOfSize:10];
        self.isFinish.text = match.hint;
    }
    else {
        self.isFinish.font = [UIFont systemFontOfSize:14];
        if ([match.isStart intValue] == 0) {
            self.isFinish.text = @"未开始";
        }
        else {
            self.isFinish.text = @"已结束";
        }
    }

    [self.emblemPathA sd_setImageWithURL:[NSURL URLWithString:match.teamA.emblemPath] placeholderImage:[UIImage imageNamed:@"teamPlaceHolderA"]];
    [self.emblemPathB sd_setImageWithURL:[NSURL URLWithString:match.teamB.emblemPath] placeholderImage:[UIImage imageNamed:@"teamPlaceHolderB"]];

    if (match.penaltyA.intValue == 0 && match.penaltyB.intValue == 0) {
        self.penaltyA.hidden = YES;
        self.penaltyB.hidden = YES;
    }
    else {
        self.penaltyA.hidden = NO;
        self.penaltyB.hidden = NO;
        self.penaltyA.text = [NSString stringWithFormat:@"(%d)", match.penaltyA.intValue];
        self.penaltyB.text = [NSString stringWithFormat:@"(%d)", match.penaltyB.intValue];
    }
}

@end
