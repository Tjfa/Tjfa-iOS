//
//  Competition.m
//  Tjfa
//
//  Created by 邱峰 on 14-3-30.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "Competition.h"
#import "Match.h"
#import "Player.h"
#import "Team.h"
#import <CoreData+MagicalRecord.h>

@implementation Competition

@dynamic competitionId;
@dynamic isStart;
@dynamic name;
@dynamic number;
@dynamic time;
@dynamic type;

@dynamic matches;
@dynamic teams;
@dynamic players;

- (NSString*)description
{
    NSDictionary* dictionary = @{
        @"competitionId" : self.competitionId,
        @"isStart" : self.isStart,
        @"name" : self.name,
        @"time" : self.time,
        @"type" : self.type,
    };
    return [dictionary description];
}

+ (NSString*)idAttributeStr
{
    return @"competitionId";
}

+ (NSString*)timeAttributeStr
{
    return @"time";
}

+ (NSString*)nameAttributeStr
{
    return @"name";
}

+ (NSString*)typeAttributeStr
{
    return @"type";
}

+ (Competition*)updateBasePropertyWithDictionary:(AVCompetition*)avCompetition
{
    NSNumber* competitionId = avCompetition.competitionId;

    Competition* competition = [Competition MR_findFirstByAttribute:[Competition idAttributeStr] withValue:competitionId];
    if (competition == nil)
        competition = [Competition MR_createEntity]; //create an new if doesn't exist

    competition.competitionId = competitionId;
    competition.type = avCompetition.type;
    competition.name = avCompetition.name;
    competition.time = avCompetition.time;
    competition.isStart = avCompetition.isStart;
    competition.number = avCompetition.number;
    return competition;
}

@end
