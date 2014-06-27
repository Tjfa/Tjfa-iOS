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

@dynamic competitionID;
@dynamic isStart;
@dynamic name;
@dynamic number;
@dynamic time;

@dynamic matches;
@dynamic teams;
@dynamic players;

+ (NSString*)idAttributeStr
{
    return @"competitionID";
}

+ (NSString*)timeAttributeStr
{
    return @"time";
}

+ (NSString*)nameAttributeStr
{
    return @"name";
}

+ (Competition*)updateBasePropertyWithDictionary:(NSDictionary*)dictionary
{
    Competition* competition = [Competition findFirstByAttribute:@"competitionID" withValue:dictionary[@"competitionID"]];
    if (competition == nil)
        competition = [Competition createEntity]; //create an new if doesn't exist
    competition.competitionID = dictionary[@"competitionID"];
    competition.name = dictionary[@"name"];
    competition.time = dictionary[@"time"];
    competition.isStart = dictionary[@"isStart"];
    competition.number = dictionary[@"number"];
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    return competition;
}

@end
