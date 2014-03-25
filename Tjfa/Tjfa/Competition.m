//
//  Competition.m
//  Tjfa
//
//  Created by 邱峰 on 14-3-25.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "Competition.h"
#import "Match.h"
#import "Team.h"


@implementation Competition

@dynamic competitionID;
@dynamic isStart;
@dynamic name;
@dynamic number;
@dynamic time;
@dynamic matches;
@dynamic teams;


+(NSString*) IdAttributeStr
{
    return @"competitionID";
}

@end
