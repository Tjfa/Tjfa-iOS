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

@interface TJMatchManager : NSObject

+ (TJMatchManager *)sharedMatchManager;

/**
 *  根据比赛信息 返回所有的 matches
 *
 *  @param competition 根据competition
 *
 *  @return array of matches
 */
- (NSArray *)getMatchesByCompetitionFromCoreData:(Competition *)competition;

/**
 *  根据搜索的时候 输入某个team的关键字  返回对应的match
 *
 *  @param teamName 如 软件 软
 *
 *  @return 包涵这个teamName的所有match
 */
- (NSArray *)getMatchesByTeamName:(NSString *)teamName
                      competition:(Competition *)compeitition;

/**
 *  根据comptition 获取服务器对应的mathches
 *
 *  @param competition 传入的competition
 *  @param complete    完成后的block
 */
- (void)getMatchesByCompetitionFromNetwork:(Competition *)competition
                                  complete:(void (^)(NSArray *results,
                                                     NSError *error))complete;


/**
 * 返回从某个时间到某个时间点的所有match  第一个 时间点间隔不要太长 一周左右比较好 
 * complete中的 NSArray 是 TJMatch类型 因此 并不保证有对应的team 需要重新find一次
 */
- (void)getMatchesFrom:(NSDate *)fromDate to:(NSDate *)toDate complete:(void (^)(NSArray *, NSError *))complete;

- (void)getMatchWithMatchId:(NSNumber *)matchId complete:(void (^)(TJMatch *, NSError *))complete;

- (void)getMatchWithObjectId:(NSString *)objectId complete:(void (^)(TJMatch *, NSError *))complete;

- (void)clearAllMatch;

@end
