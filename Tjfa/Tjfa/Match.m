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
#import <CoreData+MagicalRecord.h>
#import "TJModule.h"

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
@dynamic hint;

- (NSString *)description
{
    NSMutableDictionary *dictionary = [@{
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

+ (NSString *)idAttribute
{
    return @"matchId";
}

+ (Match *)updateMatchWithDictionary:(TJMatch *)tjMatch andCompetetion:(Competition *)competition
{
    NSNumber *matchId = tjMatch.matchId;
    Match *match = [Match MR_findFirstByAttribute:[Match idAttribute] withValue:matchId];

    if (match == nil)
        match = [Match MR_createEntity];

    match.matchId = matchId;
    match.isStart = tjMatch.isStart;
    match.date = tjMatch.date;
    match.matchProperty = tjMatch.matchProperty;
    match.scoreA = tjMatch.scoreA;
    match.scoreB = tjMatch.scoreB;
    match.winTeamId = tjMatch.winTeamId;
    match.penaltyA = tjMatch.penaltyA;
    match.penaltyB = tjMatch.penaltyB;
    match.hint = tjMatch.hint;

    match.competition = competition;

    NSNumber *teamAId = tjMatch.teamAId;
    match.teamA = [Team MR_findFirstByAttribute:[Team idAttribute] withValue:teamAId];

    NSNumber *teamBId = tjMatch.teamBId;
    match.teamB = [Team MR_findFirstByAttribute:[Team idAttribute] withValue:teamBId];

    return match;
}

@end
