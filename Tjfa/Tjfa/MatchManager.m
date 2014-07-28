//
//  MatchManager.m
//  Tjfa
//
//  Created by 邱峰 on 14-3-30.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "MatchManager.h"
#import "NetworkClient.h"
#import "TeamManager.h"

@implementation MatchManager

+ (MatchManager*)sharedMatchManager
{
    static MatchManager* _sharedMatchManager = nil;
    static dispatch_once_t matchOnceToken;
    dispatch_once(&matchOnceToken, ^() {
        _sharedMatchManager=[[MatchManager alloc] init];
    });
    return _sharedMatchManager;
}

- (NSArray*)insertMatchesWithArray:(NSArray*)array andCompetition:(Competition*)competition
{
    NSMutableArray* results = [[NSMutableArray alloc] init];
    for (NSDictionary* dictionary in array) {
        Match* match = [Match updateMatchWithDictionary:dictionary andCompetetion:competition];
        [results insertObject:match atIndex:0];
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError* error) {
        if (error){
            NSLog(@"%@",error);
        }
    }];
    return results;
}

- (NSArray*)getMatchesByCompetitionFromCoreData:(Competition*)competition
{
    NSArray* matches = [competition.matches allObjects];
    return [matches sortedArrayUsingComparator:^NSComparisonResult(Match* a, Match* b) {
        return [b.matchId compare:a.matchId];   //倒序排列
    }];
}

- (NSArray*)getMatchesByTeamName:(NSString*)teamName competition:(Competition*)competition
{
    NSSet* matchesSet = competition.matches;
    NSArray* matches = [matchesSet allObjects];
    NSMutableArray* results = [[NSMutableArray alloc] init];

    for (Match* match in matches) {
        if ([match.teamA.name rangeOfString:teamName].location != NSNotFound || [match.teamB.name rangeOfString:teamName].location != NSNotFound)
            [results addObject:match];
        break;
    }

    return results;
}

- (void)getMatchesByCompetitionFromNetwork:(Competition*)competition complete:(void (^)(NSArray*, NSError*))complete
{
    NSDictionary* parameters = @{ @"competitionId" : competition.competitionId };

    __weak MatchManager* weakSelf = self;
    [[NetworkClient sharedNetworkClient] searchForAddress:[NetworkClient matchAdderss] withParameters:parameters complete:^(NSDictionary* results, NSError* error) {
            if (error){
                complete(nil,error);
            }else{
                [[TeamManager sharedTeamManager] insertTeamsWithArray:results[@"teams"] andCompetition:competition];
                NSArray* matches=[weakSelf insertMatchesWithArray:results[@"matches"] andCompetition:competition];
                complete(matches,nil);
            }
    }];
}

- (void)clearAllMatch
{
    [Match MR_truncateAll];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

@end
