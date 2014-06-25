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

@end
