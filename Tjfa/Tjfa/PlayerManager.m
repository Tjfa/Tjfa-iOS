//
//  PlayerManager.m
//  Tjfa
//
//  Created by 邱峰 on 14-3-30.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "PlayerManager.h"
#import "NetworkClient.h"

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

- (void)getPlayersByCompetitionFromNetwork:(Competition*)competition complete:(void (^)(NSArray*, NSError*))complete
{
    NSDictionary* dictionary = @{};
    [[NetworkClient sharedNetworkClient] searchForAddress:[NetworkClient playerAddress] withParameters:dictionary complete:^(NSArray* results, NSError* error) {
        if (error){
            complete(nil,error);
        }
        else{
            complete(results,nil);
        }
    }];
}

- (NSArray*)getPlayersByKey:(NSString*)key competition:(Competition*)competition
{
    NSArray* players = [self getPlayersByCompetitionFromCoreData:competition];
    NSMutableArray* results = [[NSMutableArray alloc] init];
    for (Player* player in players) {
        if (player.name && [player.name rangeOfString:key].location != NSNotFound) {
            [results addObject:player];
        }
    }
    return results;
}

@end
