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
#import "NSNumber+Assign.h"

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
    NSNumber* teamId = [NSNumber assignValue:dictionary[@"teamId"]];

    Team* team = [Team MR_findFirstByAttribute:[Team idAttribute] withValue:teamId];
    if (team == nil)
        team = [Team MR_createEntity];

    team.teamId = teamId;
    team.emblemPath = dictionary[@"emblemPath"];
    team.groupNo = dictionary[@"groupNo"];

    team.groupGoalCount = [NSNumber assignValue:dictionary[@"groupGoalCount"]];
    team.groupMissCount = [NSNumber assignValue:dictionary[@"groupMissCount"]];
    team.goalCount = [NSNumber assignValue:dictionary[@"goalCount"]];
    team.missCount = [NSNumber assignValue:dictionary[@"missCount"]];

    team.groupWinCount = [NSNumber assignValue:dictionary[@"groupWinCount"]];
    team.groupLostCount = [NSNumber assignValue:dictionary[@"groupLostCount"]];
    team.groupDrawCount = [NSNumber assignValue:dictionary[@"groupDrawCount"]];

    team.winCount = [NSNumber assignValue:dictionary[@"winCount"]];
    team.lostCount = [NSNumber assignValue:dictionary[@"lostCount"]];

    team.name = dictionary[@"name"];
    team.score = [NSNumber assignValue:dictionary[@"score"]];
    team.rank = [NSNumber assignValue:dictionary[@"rank"]];

    team.competition = competition;

    return team;
}

@end
