//
//  AVMatch.m
//  Tjfa
//
//  Created by 邱峰 on 9/22/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TJMatch.h"

@implementation TJMatch

@dynamic date;
@dynamic matchId;
@dynamic isStart;
@dynamic matchProperty;
@dynamic scoreA;
@dynamic scoreB;
@dynamic winTeamId;
@dynamic competitionId;
@dynamic teamAId;
@dynamic teamBId;
@dynamic penaltyA;
@dynamic penaltyB;

+ (NSString *)parseClassName
{
    return @"Match";
}

@end
