//
//  TJMemberMatchCell.m
//  Tjfa
//
//  Created by 邱峰 on 4/17/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJMemberMatchCell.h"
#import "TJMatch.h"
#import "TJTeam.h"
#import "TJTeamManager.h"
#import "NSDate+Date2Str.h"

@interface TJMemberMatchCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *teamANameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamBNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation TJMemberMatchCell

- (void)prepareForReuse
{
    self.dateLabel.text = @"";
    self.teamANameLabel.text = @"";
    self.teamBNameLabel.text = @"";
    self.timeLabel.text = @"";
}

- (void)setCellWithTJMatch:(TJMatch *)match
{
    NSString *dateStr = [match.date date2str];
    NSInteger index = [dateStr rangeOfString:@" "].location;
    self.dateLabel.text = [dateStr substringToIndex:index];
    self.timeLabel.text = [dateStr substringFromIndex:index + 1];
    
    [[TJTeamManager sharedTeamManager] getTeamsByTeamId:match.teamAId complete:^(TJTeam *team, NSError *error) {
        if (team != nil) {
            self.teamANameLabel.text = team.name;
        }
    }];
    
    [[TJTeamManager sharedTeamManager] getTeamsByTeamId:match.teamBId complete:^(TJTeam *team, NSError *error) {
        if (team != nil) {
            self.teamBNameLabel.text = team.name;
        }
    }];

}

@end
