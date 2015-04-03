//
//  DatabaseManager.m
//  Tjfa
//
//  Created by 邱峰 on 6/25/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TJDatabaseManager.h"

#import "TJCompetitionManager.h"
#import "TJNewsManager.h"
#import "TJPlayerManager.h"
#import "TJMatchManager.h"
#import "TJTeamManager.h"

@implementation TJDatabaseManager

+ (TJDatabaseManager *)sharedDatabaseManager
{
    static TJDatabaseManager *_sharedDatabaseManager = nil;
    static dispatch_once_t databaseManagerToken;
    dispatch_once(&databaseManagerToken, ^(void) {
        _sharedDatabaseManager=[[TJDatabaseManager alloc] init];
    });
    return _sharedDatabaseManager;
}

- (void)clearAllData
{
    [[TJNewsManager sharedNewsManager] clearAllNews];
    [[TJCompetitionManager sharedCompetitionManager] clearAllCompetitions];
    [[TJMatchManager sharedMatchManager] clearAllMatch];
    [[TJTeamManager sharedTeamManager] clearAllTeam];
    [[TJPlayerManager sharedPlayerManager] clearAllPlayer];
}

@end
