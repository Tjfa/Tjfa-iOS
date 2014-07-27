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

+ (Competition*)updateBasePropertyWithDictionary:(NSDictionary*)dictionary
{
    Competition* competition = [Competition MR_findFirstByAttribute:[Competition idAttributeStr] withValue:dictionary[@"competitionId"]];
    if (competition == nil)
        competition = [Competition MR_createEntity]; //create an new if doesn't exist

    [self assignValue:competition.competitionId toNumber:dictionary[@"competitionId"]];
    [self assignValue:competition.type toNumber:dictionary[@"type"]];
    competition.name = dictionary[@"name"];
    competition.time = dictionary[@"time"];
    [self assignValue:competition.isStart toNumber:dictionary[@"isStart"]];
    [self assignValue:competition.number toNumber:dictionary[@"number"]];
    return competition;
}

+ (void)assignValue:(id)value toNumber:(NSNumber*)number
{
    if ([value isKindOfClass:[NSString class]]) {
        number = @([value intValue]);
    } else {
        number = value;
    }
}

@end
