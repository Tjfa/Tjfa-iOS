//
//  Match.m
//  Tjfa
//
//  Created by 邱峰 on 14-3-25.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "Match.h"
#import "Competition.h"
#import "Team.h"
#import "NSDate+Date2Str.h"

@implementation Match

@dynamic date;
@dynamic matchId;
@dynamic isStart;
@dynamic matchProperty;
@dynamic scoreA;
@dynamic scoreB;
@dynamic winTeamId;
@dynamic competition;
@dynamic teams;

- (NSString*)description
{
    NSMutableDictionary* dictionary = [@{
        @"date" : self.date,
        @"matchId" : self.matchId,
        @"isStart" : self.isStart,
        @"matchProperty" : self.matchProperty,
        @"scoreA" : self.scoreA,
        @"scoreB" : self.scoreB,
        @"winTeamId" : self.winTeamId,
        @"competitionId" : self.competition.competitionId
    } mutableCopy];

    Team* winTeam = [Team MR_findFirstByAttribute:[Team idAttribute] withValue:self.winTeamId];

    NSArray* array = [self.teams allObjects];
    Team* lostTeam = [array firstObject];

    if ([lostTeam.teamId isEqual:winTeam.teamId])
        lostTeam = [array lastObject];

    [dictionary setObject:[winTeam description] forKey:@"teamA"];
    [dictionary setObject:lostTeam forKey:@"teamB"];

    return [dictionary description];
}

+ (NSString*)idAttribute
{
    return @"matchId";
}

+ (Match*)updateMatchWithDictionary:(NSDictionary*)dictionary andCompetetion:(Competition*)competition
{
    Match* match = [Match MR_findFirstByAttribute:[Match idAttribute] withValue:dictionary[@"matchId"]];

    if (match == nil)
        match = [Match MR_createEntity];

    match.matchId = dictionary[@"matchId"];
    match.isStart = dictionary[@"isStart"];
    match.date = [NSDate str2Date:dictionary[@"date"]];
    match.matchProperty = dictionary[@"matchProperty"];
    match.scoreA = dictionary[@"scoreA"];
    match.scoreB = dictionary[@"scoreB"];
    match.winTeamId = dictionary[@"winTeamId"];
    match.competition = competition;
    [competition addMatchesObject:match];
    Team* teamA = [Team updateBasePropertyWithDictionary:dictionary[@"teamA"] competition:competition andMatch:match];
    Team* teamB = [Team updateBasePropertyWithDictionary:dictionary[@"teamB"] competition:competition andMatch:match];
    [match addTeamsObject:teamA];
    [match addTeamsObject:teamB];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

    return match;
}

@end
