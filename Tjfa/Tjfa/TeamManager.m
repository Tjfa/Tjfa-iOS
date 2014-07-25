//
//  TeamManager.m
//  Tjfa
//
//  Created by 邱峰 on 7/22/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TeamManager.h"
#import "Competition.h"
#import "NetworkClient.h"

@implementation TeamManager

+ (TeamManager*)sharedTeamManager
{
    static TeamManager* _sharedTeamManager = nil;
    static dispatch_once_t teamManagerToker;
    dispatch_once(&teamManagerToker, ^() {
        _sharedTeamManager=[[TeamManager alloc] init];
    });
    return _sharedTeamManager;
}

- (NSArray*)getTeamsFromCoreDataWithCompetition:(Competition*)competition
{
    NSArray* results = [competition.teams allObjects];
    return [results sortedArrayUsingComparator:^NSComparisonResult(Team* a, Team* b) {
        return [b.teamId compare:a.teamId];
    }];
}

- (NSArray*)getTeamsByKey:(NSString*)key competition:(Competition*)competition
{
    NSMutableArray* results = [[NSMutableArray alloc] init];
    for (Team* team in competition.teams) {
        if ([team.name rangeOfString:key].location != NSNotFound) {
            [results addObject:team];
        }
    }
    return results;
}

- (NSArray*)insertTeamsWithArray:(NSArray*)arr andCompetition:(Competition*)competition
{
    NSMutableArray* results = [[NSMutableArray alloc] init];
    for (NSDictionary* dictionary in arr) {
        Team* team = [Team updateTeamWithDictionary:dictionary competition:competition];
        [results addObject:team];
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    return results;
}

- (void)getTeamsFromNetwork:(Competition*)competition complete:(void (^)(NSArray*, NSError*))complete
{
    NSDictionary* dictionary = @{ @"competitionId" : competition.competitionId };
    __weak TeamManager* weakSelf = self;
    [[NetworkClient sharedNetworkClient] searchForAddress:[NetworkClient teamAddress] withParameters:dictionary complete:^(NSArray* results, NSError* error) {
        if (error){
            complete(nil,error);
        }
        else{
            results=[weakSelf insertTeamsWithArray:results andCompetition:competition];
            complete(results,nil);
        }
    }];
}

- (void)clearAllTeam
{
    [Team MR_truncateAll];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

@end
