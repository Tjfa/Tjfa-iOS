//
//  PlayerManager.m
//  Tjfa
//
//  Created by 邱峰 on 14-3-30.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "PlayerManager.h"

@implementation PlayerManager

+ (PlayerManager*)sharedPlayerManager
{
    static PlayerManager* _playerManager = nil;
    static dispatch_once_t playerOnceToken;
    dispatch_once(&playerOnceToken, ^(void) {
        _playerManager=[[PlayerManager alloc] init];
    });
    return _playerManager;
}

- (NSArray*)getPlayersByTeamFromCoreData:(Team*)team
{
    NSArray* result = [NSArray arrayWithObjects:team.players, nil];

    return [result sortedArrayUsingComparator:^NSComparisonResult(Player* a, Player* b) {
        return [a.name compare:b.name];
    }];
}

- (NSArray*)getPlayersByCompetitionFromCoreData:(Competition*)competition
{
    NSArray* result = [NSArray arrayWithObjects:competition.players, nil];
    return [result sortedArrayUsingComparator:^NSComparisonResult(Player* a, Player* b) {
        return [a.name compare:b.name];
    }];
}

@end
