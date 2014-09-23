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

+ (Team*)updateTeamWithDictionary:(AVTeam*)avTeam competition:(Competition*)competition
{
    NSNumber* teamId = avTeam.teamId;
    Team* team = [Team MR_findFirstByAttribute:[Team idAttribute] withValue:teamId];
    if (team == nil)
        team = [Team MR_createEntity];

    team.teamId = teamId;
    team.emblemPath = avTeam.emblemPath;
    team.groupNo = avTeam.groupNo;

    team.groupGoalCount = avTeam.groupGoalCount;
    team.groupMissCount = avTeam.groupMissCount;
    team.goalCount = avTeam.goalCount;
    team.missCount = avTeam.missCount;

    team.groupWinCount = avTeam.groupWinCount;
    team.groupLostCount = avTeam.groupLostCount;
    team.groupDrawCount = avTeam.groupDrawCount;

    team.winCount = avTeam.winCount;
    team.lostCount = avTeam.lostCount;

    team.name = avTeam.name;
    team.score = avTeam.score;
    team.rank = avTeam.rank;
    team.competition = competition;

    return team;
}

@end
