//
//  PlayerManager.m
//  Tjfa
//
//  Created by 邱峰 on 14-3-30.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "TJPlayerManager.h"
#import "TJTeamManager.h"
#import <CoreData+MagicalRecord.h>
#import "TJModule.h"

@implementation TJPlayerManager

+ (TJPlayerManager *)sharedPlayerManager
{
    static TJPlayerManager *_playerManager = nil;
    static dispatch_once_t playerOnceToken;
    dispatch_once(&playerOnceToken, ^(void) {
        _playerManager=[[TJPlayerManager alloc] init];
    });
    return _playerManager;
}

- (NSArray *)getPlayersByTeamFromCoreData:(Team *)team
{
    NSArray *result = [NSArray arrayWithObjects:team.players, nil];

    return [result sortedArrayUsingComparator:^NSComparisonResult(Player *a, Player *b) {
        return [a.name compare:b.name];
    }];
}

- (NSArray *)getPlayersByCompetitionFromCoreData:(Competition *)competition
{
    NSSet *playerSet = competition.players;
    NSArray *result = [playerSet allObjects];
    return [result sortedArrayUsingComparator:^NSComparisonResult(Player *a, Player *b) {
        return [a.name compare:b.name];
    }];
}

- (NSArray *)insertPlayersWithArray:(NSArray *)array competition:(Competition *)competition
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (TJPlayer *avPlayer in array) {
        Player *player = [Player updatePlayerWithDictionary:avPlayer competition:competition];
        [results addObject:player];
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (error){
            NSLog(@"%@",error);
        }
    }];
    return results;
}

- (void)getPlayersByCompetitionFromNetwork:(Competition *)competition complete:(void (^)(NSArray *, NSError *))complete
{
    //    NSDictionary* dictionary = @{ @"competitionId" : competition.competitionId };
    //
    //    [[NetworkClient sharedNetworkClient] searchForAddress:[NetworkClient playerAddress] withParameters:dictionary complete:^(NSDictionary* results, NSError* error) {
    //        if (error){
    //            complete(nil,error);
    //        }
    //        else{
    //            [[TeamManager sharedTeamManager] insertTeamsWithArray:results[@"teams"] andCompetition:competition];
    //            NSArray* players=[self insertPlayersWithArray:results[@"players"] competition:competition];
    //            complete(players,nil);
    //        }
    //    }];

    __weak typeof(self) weakSelf = self;

    AVQuery *teamQuery = [TJTeam query];
    teamQuery.limit = 1000;
    [teamQuery whereKey:@"competitionId" equalTo:competition.competitionId];
    [teamQuery findObjectsInBackgroundWithBlock:^(NSArray *teamResults, NSError *error) {
        if (error){
            complete(nil,error);
            return ;
        }else{
            [[TJTeamManager sharedTeamManager] insertTeamsWithArray:teamResults andCompetition:competition];
            
            AVQuery* query=[TJPlayer query];
            query.limit=1000;
            [query whereKey:@"competitionId" equalTo:competition.competitionId];
            [query findObjectsInBackgroundWithBlock:^(NSArray* results, NSError* error){
                if (error){
                    complete(nil,error);
                }else{
                    NSArray* players=[weakSelf insertPlayersWithArray:results competition:competition];
                    complete(players,nil);
                }
            }];
        }
    }];
}

- (NSArray *)getPlayersByKey:(NSString *)key competition:(Competition *)competition
{
    NSArray *players = [self getPlayersByCompetitionFromCoreData:competition];
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (Player *player in players) {
        if (player.name && [player.name rangeOfString:key].location != NSNotFound) {
            [results addObject:player];
        }
    }
    return results;
}

- (void)clearAllPlayer
{
    [Player MR_truncateAll];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

@end
