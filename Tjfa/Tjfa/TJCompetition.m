//
//  AVCompetition.m
//  Tjfa
//
//  Created by 邱峰 on 9/22/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TJCompetition.h"

@implementation TJCompetition

@dynamic competitionId;
@dynamic isStart;
@dynamic name;
@dynamic number;
@dynamic time;
@dynamic type;

+ (NSString*)parseClassName
{
    return @"Competition";
}

@end
