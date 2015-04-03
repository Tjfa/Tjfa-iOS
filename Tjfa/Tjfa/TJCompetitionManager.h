//
//  CompetitionManager.h
//  Tjfa
//
//  Created by 邱峰 on 14-3-25.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Competition.h"

@interface TJCompetitionManager : NSObject

+ (TJCompetitionManager *)sharedCompetitionManager;

- (void)clearAllCompetitions;

/**
 *  从数据库拿到对应的比赛性质
 *
 *  @param type 1代表本部比赛 2代表嘉定比赛
 *
 *  @return array of Competition
 */
- (NSArray *)getCompetitionsFromCoreDataWithType:(NSNumber *)type;

/**
 *  获取更糟的competitions  下拉刷新完以后  界面刷新只显示 get latest里面的matches  这时候 可能要加载以前的competition 保证数据库是最新的
 *
 *  @param competitionId 获取 competitionId之前的compeotition
 *  @param type          type 1代表本部比赛 2代表嘉定比赛
 *  @param limit         获取 compeotition的个数
 *  @param complete      完成后的block  函数会自动更新数据库
 */
- (void)getEarlierCompetitionsFromNetwork:(NSNumber *)competitionId withType:(NSNumber *)type limit:(int)limit complete:(void (^)(NSArray *results, NSError *error))complete;

/**
 *  获取最新的competitions  用于下拉刷新用
 *
 *  @param type     1 代表本部 2代表嘉定
 *  @param limit    获取competition的个数
 *  @param complete 完成后的block
 */
- (void)getLatestCompetitionsFromNetworkWithType:(NSNumber *)type limit:(int)limit complete:(void (^)(NSArray *results, NSError *error))complete;

- (void)getCompeitionWithCompetitionId:(NSNumber *)competionId complete:(void (^)(Competition *, NSError *))complete;

@end
