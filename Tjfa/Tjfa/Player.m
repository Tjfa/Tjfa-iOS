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
#import <CoreData+MagicalRecord.h>
#import "TJPlayer.h"

@implementation Player

@dynamic goalCount;
@dynamic playerId;
@dynamic name;
@dynamic redCard;
@dynamic yellowCard;
@dynamic team;
@dynamic competition;

+ (NSString *)idAttributeStr
{
    return @"playerId";
}

+ (NSString *)yellowCardAttributeStr
{
    return @"yellowCard";
}

+ (NSString *)redCardAttributeStr
{
    return @"redCard";
}

+ (NSString *)goalCountAttributeStr
{
    return @"goalCount";
}

+ (Player *)updatePlayerWithDictionary:(TJPlayer *)tjPlayer competition:(Competition *)competition;
{

    NSNumber *playerId = tjPlayer.playerId;
    Player *player = [Player MR_findFirstByAttribute:[self idAttributeStr] withValue:playerId];
    if (player == nil) {
        player = [Player MR_createEntity];
    }
    player.playerId = playerId;
    player.goalCount = tjPlayer.goalCount;
    player.name = tjPlayer.name;
    player.redCard = tjPlayer.redCard;
    player.yellowCard = tjPlayer.yellowCard;

    player.competition = competition;
    NSNumber *teamId = tjPlayer.teamId;
    player.team = [Team MR_findFirstByAttribute:[Team idAttribute] withValue:teamId];
    return player;
}

@end
