//
//  Player.m
//  Tjfa
//
//  Created by 邱峰 on 14-3-25.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "Player.h"
#import "Team.h"

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

@end
