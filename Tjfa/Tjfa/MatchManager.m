//
//  MatchManager.m
//  Tjfa
//
//  Created by 邱峰 on 14-3-30.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "MatchManager.h"

@implementation MatchManager

+ (MatchManager*)sharedMatchManager
{
    static MatchManager* _sharedMatchManager = nil;
    static dispatch_once_t matchOnceToken;
    dispatch_once(&matchOnceToken, ^() {
        _sharedMatchManager=[[MatchManager alloc] init];
    });
    return _sharedMatchManager;
}

- (NSArray*)getMatchesByCompetition:(Competition*)competition
{
    NSArray* result = [NSArray arrayWithObjects:competition.matches, nil];

    return [result sortedArrayUsingComparator:^NSComparisonResult(Match* a, Match* b) {
        return [a.date compare:b.date];
    }];
}

@end
