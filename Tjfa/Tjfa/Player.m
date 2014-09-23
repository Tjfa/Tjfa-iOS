//
//  Player.m
//  Tjfa
//
//  Created by 邱峰 on 14-3-25.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "Player.h"
#import "Team.h"
#import "Competition.h"
#import "NSNumber+Assign.h"
#import <CoreData+MagicalRecord.h>

@implementation Player

@dynamic goalCount;
@dynamic playerId;
@dynamic name;
@dynamic redCard;
@dynamic yellowCard;
@dynamic team;
@dynamic competition;

+ (NSString*)idAttributeStr
{
    return @"playerId";
}

+ (NSString*)yellowCardAttributeStr
{
    return @"yellowCard";
}

+ (NSString*)redCardAttributeStr
{
    return @"redCard";
}

+ (NSString*)goalCountAttributeStr
{
    return @"goalCount";
}

+ (Player*)updatePlayerWithDictionary:(NSDictionary*)dictionary competition:(Competition*)competition;
{

    NSNumber* playerId = [NSNumber assignValue:dictionary[@"playerId"]];
    Player* player = [Player MR_findFirstByAttribute:[self idAttributeStr] withValue:playerId];
    if (player == nil) {
        player = [Player MR_createEntity];
    }
    player.playerId = playerId;
    player.goalCount = [NSNumber assignValue:dictionary[@"goalCount"]];
    player.name = dictionary[@"name"];
    player.redCard = [NSNumber assignValue:dictionary[@"redCard"]];
    player.yellowCard = [NSNumber assignValue:dictionary[@"yellowCard"]];

    player.competition = competition;
    NSNumber* teamId = [NSNumber assignValue:dictionary[@"teamId"]];
    player.team = [Team MR_findFirstByAttribute:[Team idAttribute] withValue:teamId];
    return player;
}

@end
