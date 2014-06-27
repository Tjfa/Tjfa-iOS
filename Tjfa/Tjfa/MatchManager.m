//
//  MatchManager.m
//  Tjfa
//
//  Created by 邱峰 on 14-3-30.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "MatchManager.h"
#import "NetworkClient.h"

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

- (NSArray*)insertMatchesWitchArray:(NSArray*)array andCompetition:(Competition*)competition
{
    NSMutableArray* results = [[NSMutableArray alloc] init];
    for (NSDictionary* dictionary in array) {
        Match* match = [Match updateMatchWithDictionary:dictionary andCompetetion:competition];
        [results addObject:match];
    }
    return results;
}

- (NSArray*)getMatchesByCompetitionFromCoreData:(Competition*)competition
{
    NSArray* matches = [competition.matches allObjects];
    return [matches sortedArrayUsingComparator:^NSComparisonResult(Match* a, Match* b) {
        return [a.matchId compare:b.matchId];
    }];
}

- (void)getMatchesByCompetitionFromNetwork:(Competition*)competition complete:(void (^)(NSArray*, NSError*))complete
{
    NSDictionary* parameters = @{ @"competitionId" : competition.competitionId };
    [[NetworkClient sharedNetworkClient] searchForAddress:[NetworkClient matchAdderss] withParameters:parameters complete:^(NSArray* results, NSError* error) {
            if (error){
                complete(nil,error);
            }else{
                results=[self insertMatchesWitchArray:results andCompetition:competition];
                complete(results,nil);
            }
    }];
}

@end
