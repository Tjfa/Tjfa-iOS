//
//  MatchManager.h
//  Tjfa
//
//  Created by 邱峰 on 14-3-30.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Competition.h"
#import "Match.h"

@interface MatchManager : NSObject

+ (MatchManager*)sharedMatchManager;

/**
 *  根据比赛信息 返回所有的 matches
 *
 *  @param competition 根据competition
 *
 *  @return array of matches
 */
- (NSArray*)getMatchesByCompetitionFromCoreData:(Competition*)competition;

/**
 *  根据搜索的时候 输入某个team的关键字  返回对应的match
 *
 *  @param teamName 软件 软
 *
 *  @return 包涵这个teamName的所有match
 */
- (NSArray*)getMatchesByTeamName:(NSString*)teamName competition:(Competition*)compeitition;

- (void)getMatchesByCompetitionFromNetwork:(Competition*)competition complete:(void (^)(NSArray* results, NSError* error))complete;

@end
