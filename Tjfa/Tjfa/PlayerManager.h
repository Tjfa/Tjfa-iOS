//
//  PlayerManager.h
//  Tjfa
//
//  Created by 邱峰 on 14-3-30.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Player.h"
#import "Team.h"
#import "Match.h"
#import "Competition.h"

@interface PlayerManager : NSObject

+ (PlayerManager*)sharedPlayerManager;

/**
 *  获取某个队伍的球员
 *
 *  @param team <#team description#>
 *
 *  @return <#return value description#>
 */
- (NSArray*)getPlayersByTeamFromCoreData:(Team*)team;

- (NSArray*)getPlayersByCompetitionFromCoreData:(Competition*)competition;

- (NSArray*)getYellowCardListFromCoreData:(Competition*)competition;

- (void)getYellowCardListFromNetworkCompetition:(Competition*)competition complete:(void (^)(NSArray* results, NSError* error))complete;

@end
