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

- (Player*)getPlayerByIdFromCoreData:(int)playerId;

- (NSArray*)getPlayersByTeamFromCoreData:(Team*)team;

- (NSArray*)getPlayersByCompetitionFromCoreData:(Competition*)competition;

@end
