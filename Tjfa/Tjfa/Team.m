//
//  Team.m
//  Tjfa
//
//  Created by 邱峰 on 6/28/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "Team.h"
#import "Competition.h"
#import "Match.h"
#import "Player.h"
#import <CoreData+MagicalRecord.h>
#import "TJTeam.h"

@implementation Team

@dynamic emblemPath;
@dynamic goalCount;
@dynamic groupNo;
@dynamic missCount;
@dynamic name;
@dynamic score;
@dynamic teamId;
@dynamic competition;
@dynamic players;
@dynamic groupGoalCount;
@dynamic groupMissCount;
@dynamic groupWinCount;
@dynamic groupDrawCount;
@dynamic groupLostCount;
@dynamic winCount;
@dynamic lostCount;
@dynamic rank;

- (NSString*)description
{
    NSDictionary* dictionary = @{
        @"emblemPath" : self.emblemPath,
        @"goalCount" : self.goalCount,
        @"groupNo" : self.groupNo,
        @"missCount" : self.missCount,
        @"name" : self.name,
        @"score" : self.score,
        @"teamId" : self.teamId,
    };
    return [dictionary description];
}

+ (NSString*)idAttribute
{
    return @"teamId";
}

+ (Team*)updateTeamWithDictionary:(TJTeam *)tjTeam competition:(Competition*)competition
{
    NSNumber* teamId = tjTeam.teamId;
    Team* team = [Team MR_findFirstByAttribute:[Team idAttribute] withValue:teamId];
    if (team == nil)
        team = [Team MR_createEntity];

    team.teamId = teamId;
    team.emblemPath = tjTeam.emblemPath;
    team.groupNo = tjTeam.groupNo;

    team.groupGoalCount = tjTeam.groupGoalCount;
    team.groupMissCount = tjTeam.groupMissCount;
    team.goalCount = tjTeam.goalCount;
    team.missCount = tjTeam.missCount;

    team.groupWinCount = tjTeam.groupWinCount;
    team.groupLostCount = tjTeam.groupLostCount;
    team.groupDrawCount = tjTeam.groupDrawCount;

    team.winCount = tjTeam.winCount;
    team.lostCount = tjTeam.lostCount;

    team.name = tjTeam.name;
    team.score = tjTeam.score;
    team.rank = tjTeam.rank;
    team.competition = competition;

    return team;
}

@end
