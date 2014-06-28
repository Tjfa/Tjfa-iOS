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
        @"type":self.type,
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

+ (Competition*)updateBasePropertyWithDictionary:(NSDictionary*)dictionary
{
    Competition* competition = [Competition MR_findFirstByAttribute:[Competition idAttributeStr] withValue:dictionary[@"competitionId"]];
    if (competition == nil)
        competition = [Competition MR_createEntity]; //create an new if doesn't exist

    competition.competitionId = dictionary[@"competitionId"];
    competition.type = dictionary[@"type"];
    competition.name = dictionary[@"name"];
    competition.time = dictionary[@"time"];
    competition.isStart = dictionary[@"isStart"];
    competition.number = dictionary[@"number"];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    return competition;
}

@end
