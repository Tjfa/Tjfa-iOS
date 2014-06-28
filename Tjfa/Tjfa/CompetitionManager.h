//
//  CompetitionManager.h
//  Tjfa
//
//  Created by 邱峰 on 14-3-25.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Competition.h"

@interface CompetitionManager : NSObject

+ (CompetitionManager*)sharedCompetitionManager;

- (void)clearAllCompetitions;

/**
 *  从数据库拿到对应的比赛性质
 *
 *  @param type 1代表本部比赛 2代表嘉定比赛
 *
 *  @return array of Competition
 */
- (NSArray*)getCompetitionsFromCoreDataWithType:(NSNumber*)type;

- (void)getEarlierCompetitionsFromNetwork:(NSNumber*)competitionId withType:(NSNumber*)type limit:(int)limit complete:(void (^)(NSArray* results, NSError* error))complete;

- (void)getLatestCompetitionsFromNetworkWithType:(NSNumber*)type limit:(int)limit complete:(void (^)(NSArray* results, NSError* error))complete;

@end
