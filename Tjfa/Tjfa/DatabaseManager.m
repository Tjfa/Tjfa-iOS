//
//  DatabaseManager.m
//  Tjfa
//
//  Created by 邱峰 on 6/25/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "DatabaseManager.h"

#import "CompetitionManager.h"
#import "NewsManager.h"

@implementation DatabaseManager

+ (DatabaseManager*)sharedDatabaseManager
{
    static DatabaseManager* _sharedDatabaseManager = nil;
    static dispatch_once_t databaseManagerToken;
    dispatch_once(&databaseManagerToken, ^(void) {
        _sharedDatabaseManager=[[DatabaseManager alloc] init];
    });
    return _sharedDatabaseManager;
}

- (void)clearAllData
{

    [[NewsManager sharedNewsManager] clearAllNews];
    [[CompetitionManager sharedCompetitionManager] clearAllCompetitions];
}

@end
