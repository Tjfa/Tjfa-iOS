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
#import "NSNumber+Assign.h"

@implementation Match

@dynamic date;
@dynamic matchId;
@dynamic isStart;
@dynamic matchProperty;
@dynamic scoreA;
@dynamic scoreB;
@dynamic winTeamId;
@dynamic competition;
@dynamic teamA;
@dynamic teamB;
@dynamic penaltyA;
@dynamic penaltyB;

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

    [dictionary setObject:[self.teamA description] forKey:@"teamA"];
    [dictionary setObject:self.teamB forKey:@"teamB"];

    return [dictionary description];
}

+ (NSString*)idAttribute
{
    return @"matchId";
}

+ (Match*)updateMatchWithDictionary:(NSDictionary*)dictionary andCompetetion:(Competition*)competition
{
    NSNumber* matchId = [NSNumber assignValue:dictionary[@"matchId"]];
    Match* match = [Match MR_findFirstByAttribute:[Match idAttribute] withValue:matchId];

    if (match == nil)
        match = [Match MR_createEntity];

    match.matchId = matchId;
    match.isStart = [NSNumber assignValue:dictionary[@"isStart"]];
    match.date = [NSDate str2Date:dictionary[@"date"]];
    match.matchProperty = [NSNumber assignValue:dictionary[@"matchProperty"]];
    match.scoreA = [NSNumber assignValue:dictionary[@"scoreA"]];
    match.scoreB = [NSNumber assignValue:dictionary[@"scoreB"]];
    match.winTeamId = [NSNumber assignValue:dictionary[@"winTeamId"]];
    match.penaltyA = [NSNumber assignValue:dictionary[@"penaltyA"]];
    match.penaltyB = [NSNumber assignValue:dictionary[@"penaltyB"]];

    match.competition = competition;

    NSNumber* teamAId = [NSNumber assignValue:dictionary[@"teamAId"]];
    match.teamA = [Team MR_findFirstByAttribute:[Team idAttribute] withValue:teamAId];

    NSNumber* teamBId = [NSNumber assignValue:dictionary[@"teamBId"]];
    match.teamB = [Team MR_findFirstByAttribute:[Team idAttribute] withValue:teamBId];

    return match;
}

@end
