//
//  TeamManager.m
//  Tjfa
//
//  Created by 邱峰 on 7/22/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TJTeamManager.h"
#import "TJCompetition.h"
#import <CoreData+MagicalRecord.h>
#import "TJModule.h"
#import "Competition.h"

@implementation TJTeamManager

+ (TJTeamManager *)sharedTeamManager
{
    static TJTeamManager *_sharedTeamManager = nil;
    static dispatch_once_t teamManagerToker;
    dispatch_once(&teamManagerToker, ^() {
        _sharedTeamManager=[[TJTeamManager alloc] init];
    });
    return _sharedTeamManager;
}

- (NSArray *)getTeamsFromCoreDataWithCompetition:(Competition *)competition
{
    NSArray *results = [competition.teams allObjects];
    return [results sortedArrayUsingComparator:^NSComparisonResult(Team *a, Team *b) {
        return [b.teamId compare:a.teamId];
    }];
}

- (NSArray *)getTeamsByKey:(NSString *)key competition:(Competition *)competition
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (Team *team in competition.teams) {
        if ([team.name rangeOfString:key].location != NSNotFound) {
            [results addObject:team];
        }
    }
    return results;
}

- (NSArray *)insertTeamsWithArray:(NSArray *)arr andCompetition:(Competition *)competition
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (TJTeam *tjTeam in arr) {
        Team *team = [Team updateTeamWithDictionary:tjTeam competition:competition];
        [results addObject:team];
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (error){
            NSLog(@"%@",error);
        }
    }];
    return results;
}

- (void)getTeamsFromNetwork:(Competition *)competition complete:(void (^)(NSArray *, NSError *))complete
{
    __weak typeof(self) weakSelf = self;

    AVQuery *query = [TJTeam query];
    [query whereKey:@"competitionId" equalTo:competition.competitionId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (error) {
            complete(nil,error);
        }
        else {
            results=[weakSelf insertTeamsWithArray:results andCompetition:competition];
            complete(results,nil);
        }
    }];
}

- (void)getTeamsByTeamId:(NSNumber *)teamId complete:(void (^)(TJTeam *, NSError *))complete
{
    AVQuery *query = [TJTeam query];
    [query whereKey:@"teamId" equalTo:teamId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error){
        if (complete) {
            if (error) {
                complete(nil, error);
            }
            else {
                if (results.count == 0) {
                    complete(nil, [[NSError alloc] init]);
                }
                else {
                    complete([results firstObject], nil);
                }
            }
        }
    }];
}

- (void)clearAllTeam
{
    [Team MR_truncateAll];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

@end
