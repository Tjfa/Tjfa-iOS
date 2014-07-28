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

+ (Team*)updateTeamWithDictionary:(NSDictionary*)dictionary competition:(Competition*)competition
{
    Team* team = [Team MR_findFirstByAttribute:[Team idAttribute] withValue:dictionary[@"teamId"]];
    if (team == nil)
        team = [Team MR_createEntity];
    team.teamId = dictionary[@"teamId"];
    team.emblemPath = dictionary[@"emblemPath"];
    team.groupNo = dictionary[@"groupNo"];
    team.goalCount = dictionary[@"goalCount"];
    team.missCount = dictionary[@"missCount"];
    team.name = dictionary[@"name"];
    team.score = dictionary[@"score"];
    team.rank = dictionary[@"rank"];
    team.groupMissCount = dictionary[@"groupMissCount"];
    team.groupGoalCount = dictionary[@"groupGoalCount"];
    team.competition = competition;

    return team;
}

@end
