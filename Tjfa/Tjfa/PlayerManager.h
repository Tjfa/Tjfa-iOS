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
 *  从本地获取所有关于球员的信息
 *
 *  @param team 传入team的信息
 *
 *  @return 返回array
 */
- (NSArray*)getPlayersByTeamFromCoreData:(Team*)team;

/**
 *  从本地获取所有关于某个赛事的球员信息
 *
 *  @param competition 传入比赛的信息
 *
 *  @return 返回球员的array
 */
- (NSArray*)getPlayersByCompetitionFromCoreData:(Competition*)competition;

/**
 *  根据competition从网络获取player的信息
 *
 *  @param competition 输入参数 competition
 *  @param complete    获取结束后回调的block 会自动切换到主线程
 */
- (void)getPlayersByCompetitionFromNetwork:(Competition*)competition complete:(void (^)(NSArray* results, NSError* error))complete;

- (NSArray*)getPlayersByKey:(NSString*)key competition:(Competition*)competition;
@end
