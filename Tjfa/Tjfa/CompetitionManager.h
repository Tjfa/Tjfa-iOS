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

- (NSArray*)getCompetitionsFromCoreData;

- (void)getEarlierCompetitionsFromNetwork:(NSNumber*)competitionId withLimit:(int)limit complete:(void (^)(NSArray* results, NSError* error))complete;

- (void)getLatestCompetitionsFromNetworkWithLimit:(int)limit complete:(void (^)(NSArray* results, NSError* error))complete;

@end
