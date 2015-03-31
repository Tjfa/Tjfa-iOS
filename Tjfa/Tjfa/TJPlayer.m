//
//  AVMatchPlayer.m
//  Tjfa
//
//  Created by 邱峰 on 9/22/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TJPlayer.h"

@implementation TJPlayer

@dynamic goalCount;
@dynamic playerId;
@dynamic name;
@dynamic redCard;
@dynamic yellowCard;
@dynamic teamId;
@dynamic competitionId;

+ (NSString*)parseClassName
{
    return @"Player";
}

@end
