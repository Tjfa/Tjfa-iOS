//
//  AVTeam.m
//  Tjfa
//
//  Created by 邱峰 on 9/22/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TJTeam.h"

@implementation TJTeam

@dynamic emblemPath;
@dynamic goalCount;
@dynamic groupNo;
@dynamic missCount;
@dynamic name;
@dynamic score;
@dynamic teamId;
@dynamic competitionId;
@dynamic players;
@dynamic groupGoalCount;
@dynamic groupMissCount;
@dynamic groupWinCount;
@dynamic groupDrawCount;
@dynamic groupLostCount;
@dynamic winCount;
@dynamic lostCount;
@dynamic rank;

+ (NSString*)parseClassName
{
    return @"Team";
}

@end
