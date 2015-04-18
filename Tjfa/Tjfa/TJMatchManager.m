//
//  MatchManager.m
//  Tjfa
//
//  Created by 邱峰 on 14-3-30.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "TJMatchManager.h"
#import "TJNetworkClient.h"
#import "TJTeamManager.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import <AVOSCloud.h>
#import "TJModule.h"

@implementation TJMatchManager

+ (TJMatchManager *)sharedMatchManager
{
    static TJMatchManager *_sharedMatchManager = nil;
    static dispatch_once_t matchOnceToken;
    dispatch_once(&matchOnceToken, ^() {
        _sharedMatchManager=[[TJMatchManager alloc] init];
    });
    return _sharedMatchManager;
}

- (NSArray *)insertMatchesWithArray:(NSArray *)array andCompetition:(Competition *)competition
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (TJMatch *avMatch in array) {
        Match *match = [Match updateMatchWithDictionary:avMatch andCompetetion:competition];
        [results insertObject:match atIndex:0];
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    return results;
}

- (NSArray *)getMatchesByCompetitionFromCoreData:(Competition *)competition
{
    NSArray *matches = [competition.matches allObjects];
    return [matches sortedArrayUsingComparator:^NSComparisonResult(Match *a, Match *b) {
        return [b.matchId compare:a.matchId];   //倒序排列
    }];
}

- (NSArray *)getMatchesByTeamName:(NSString *)teamName competition:(Competition *)competition
{
    NSArray *matches = [competition.matches allObjects];
    NSMutableArray *results = [[NSMutableArray alloc] init];

    for (Match *match in matches) {
        if ([match.teamA.name.lowercaseString rangeOfString:teamName.lowercaseString].location != NSNotFound || [match.teamB.name.lowercaseString rangeOfString:teamName.lowercaseString].location != NSNotFound) {
            [results addObject:match];
        }
    }

    return results;
}

- (void)getMatchesFrom:(NSDate *)fromDate to:(NSDate *)toDate complete:(void (^)(NSArray *, NSError *))complete
{
    AVQuery *query = [TJMatch query];
    [query whereKey:@"date" greaterThanOrEqualTo:fromDate];
    [query whereKey:@"date" lessThanOrEqualTo:toDate];
    [query findObjectsInBackgroundWithBlock:^(NSArray *matches, NSError *error) {
        if (complete) {
            complete(matches, error);
        }
    }];
}

- (void)getMatchWithMatchId:(NSNumber *)matchId complete:(void (^)(NSArray *, NSError *))complete
{
    AVQuery *query = [TJMatch query];
    [query whereKey:@"matchId" equalTo:matchId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *matches, NSError *error) {
        if (error) {
            complete(nil,error);
        }
        else {
            if (matches.count > 0) {
                complete([matches firstObject], nil);
            }
            else {
                complete(nil, [[NSError alloc] init]);
            }
        }
    }];
}

- (void)getMatchWithObjectId:(NSString *)objectId complete:(void (^)(NSArray *, NSError *))complete
{
    AVQuery *query = [TJMatch query];
    [query whereKey:@"objectId" equalTo:objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *matches, NSError *error) {
        if (error) {
            complete(nil,error);
        }
        else {
            if (matches.count > 0) {
                complete([matches firstObject], nil);
            }
            else {
                complete(nil, [[NSError alloc] init]);
            }
        }
    }];

}

- (void)getMatchesByCompetitionFromNetwork:(Competition *)competition complete:(void (^)(NSArray *, NSError *))complete
{
    __weak typeof(self) weakSelf = self;
    AVQuery *teamQuery = [TJTeam query];
    [teamQuery whereKey:@"competitionId" equalTo:competition.competitionId];
    [teamQuery findObjectsInBackgroundWithBlock:^(NSArray *teamsResult, NSError *error) {
        if (error) {
            complete(nil,error);
        }
        else {
            [[TJTeamManager sharedTeamManager] insertTeamsWithArray:teamsResult andCompetition:competition];
            
            AVQuery* avquery = [TJMatch query];
            [avquery whereKey:@"competitionId" equalTo:competition.competitionId];
            [avquery findObjectsInBackgroundWithBlock:^(NSArray* results, NSError* error) {
                if (error) {
                    complete(nil,error);
                }
                else {
                    NSArray* matches=[weakSelf insertMatchesWithArray:results andCompetition:competition];
                    complete(matches,nil);
                }
            }];
        }
    }];
}

- (void)clearAllMatch
{
    [Match MR_truncateAll];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

@end
