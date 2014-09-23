//
//  CompetitionManager.m
//  Tjfa
//
//  Created by 邱峰 on 14-3-25.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "CompetitionManager.h"
#import "AFNetworking.h"
#import "NSDate+Date2Str.h"
#import "NetworkClient.h"
#import <CoreData+MagicalRecord.h>
#import "AVCompetition.h"

@implementation CompetitionManager

+ (CompetitionManager*)sharedCompetitionManager
{
    static CompetitionManager* _sharedCompetitionManager = nil;
    static dispatch_once_t competitionOnceToken;
    dispatch_once(&competitionOnceToken, ^{
        _sharedCompetitionManager=[[CompetitionManager alloc] init];
    });
    return _sharedCompetitionManager;
}

- (void)clearAllCompetitions
{
    [Competition MR_truncateAll];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (NSArray*)insertCompetitionsWithArray:(NSArray*)array
{
    NSMutableArray* results = [[NSMutableArray alloc] init];
    for (AVCompetition* avCompetition in array) {
        Competition* competition = [Competition updateBasePropertyWithDictionary:avCompetition];
        [results insertObject:competition atIndex:0];
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError* error) {
        if (error){
            NSLog(@"%@",error);
        }
    }];
    [results sortUsingComparator:^NSComparisonResult(Competition* a, Competition* b) {
        return [b.competitionId compare:a.competitionId];
    }];
    return results;
}

- (NSArray*)getCompetitionsFromCoreDataWithType:(NSNumber*)type
{
    return [Competition MR_findByAttribute:[Competition typeAttributeStr] withValue:type andOrderBy:[Competition idAttributeStr] ascending:NO];
}

- (void)getEarlierCompetitionsFromNetwork:(NSNumber*)competitionId withType:(NSNumber*)type limit:(int)limit complete:(void (^)(NSArray*, NSError*))complete
{
    //    NSLog(@"%@ %@", type, competitionId);
    //    NSDictionary* parameterDictionary = @{ @"type" : type,
    //                                           @"competitionId" : competitionId,
    //                                           @"limit" : @(limit) };

    __weak CompetitionManager* weakSelf = self;
    AVQuery* query = [AVQuery queryWithClassName:@"Competition"];
    [query whereKey:@"type" equalTo:type];
    [query whereKey:@"competitionId" lessThan:competitionId];
    query.limit = limit;
    [query findObjectsInBackgroundWithBlock:^(NSArray* results, NSError* error) {
        if (error){
            complete(nil,error);
        }else{
            results=[weakSelf insertCompetitionsWithArray:results];
            complete(results,nil);
        }
    }];

    //    [[NetworkClient sharedNetworkClient] searchForAddress:[NetworkClient competitionAddress] withParameters:parameterDictionary complete:^(NSArray* results, NSError* error) {
    //            if (error){
    //                complete(nil,error);
    //            }else{
    //                results=[weakSelf insertCompetitionsWithArray:results];
    //                complete(results,nil);
    //            }
    //    }];
}

- (void)getLatestCompetitionsFromNetworkWithType:(NSNumber*)type limit:(int)limit complete:(void (^)(NSArray*, NSError*))complete
{
    [self getEarlierCompetitionsFromNetwork:@(1 << 30) withType:type limit:limit complete:complete];
}

@end
