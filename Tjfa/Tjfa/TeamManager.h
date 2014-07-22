//
//  TeamManager.h
//  Tjfa
//
//  Created by 邱峰 on 7/22/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"

@interface TeamManager : NSObject

+ (TeamManager*)sharedTeamManager;

- (void)clearAllTeam;

- (NSArray*)getTeamsFromCoreDataWithCompetition:(Competition*)competition;

- (NSArray*)getTeamsByKey:(NSString*)key competition:(Competition*)competition;

- (void)getTeamsFromNetwork:(Competition*)competition complete:(void (^)(NSArray* results, NSError* error))complete;

@end
