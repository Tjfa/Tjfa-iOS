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

+ (Player*)updatePlayerWithDictionary:(NSDictionary*)dictionary
{
    NSNumber* playerId = dictionary[@"playerId"];
    Player* player = [Player MR_findFirstByAttribute:[self idAttributeStr] withValue:playerId];
    if (player == nil) {
        player = [Player MR_createEntity];
    }
    player.playerId = playerId;
    player.goalCount = dictionary[@"goalCount"];
    player.name = dictionary[@"name"];
    player.redCard = dictionary[@"redCard"];
    player.yellowCard = dictionary[@"yellowCard"];
    NSNumber* competitionId = dictionary[@"competitionId"];
    player.competition = [Competition MR_findFirstByAttribute:[Competition idAttributeStr] withValue:competitionId];
#warning what if team no found?
    NSNumber* teamId = dictionary[@"teamId"];
    player.team = [Team MR_findFirstByAttribute:[Team idAttribute] withValue:teamId];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    return player;
}

@end
