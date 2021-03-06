//
//  CompetitionManager.m
//  Tjfa
//
//  Created by 邱峰 on 14-3-25.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "TJCompetitionManager.h"
#import "NSDate+Date2Str.h"
#import <CoreData+MagicalRecord.h>
#import "TJModule.h"

@implementation TJCompetitionManager

+ (TJCompetitionManager *)sharedCompetitionManager
{
    static TJCompetitionManager *_sharedCompetitionManager = nil;
    static dispatch_once_t competitionOnceToken;
    dispatch_once(&competitionOnceToken, ^{
        _sharedCompetitionManager=[[TJCompetitionManager alloc] init];
    });
    return _sharedCompetitionManager;
}

- (void)clearAllCompetitions
{
    [Competition MR_truncateAll];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (NSArray *)insertCompetitionsWithArray:(NSArray *)array
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (TJCompetition *tjCompetition in array) {
        Competition *competition = [Competition updateBasePropertyWithDictionary:tjCompetition];
        [results insertObject:competition atIndex:0];
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    [results sortUsingComparator:^NSComparisonResult(Competition *a, Competition *b) {
        return [b.competitionId compare:a.competitionId];
    }];
    return results;
}

- (NSArray *)getCompetitionsFromCoreDataWithType:(NSNumber *)type
{
    return [Competition MR_findByAttribute:[Competition typeAttributeStr] withValue:type andOrderBy:[Competition idAttributeStr] ascending:NO];
}

- (void)getCompeitionWithCompetitionId:(NSNumber *)competionId complete:(void (^)(Competition *, NSError *))complete
{
    Competition *competition = [Competition MR_findFirstByAttribute:@"competitionId" withValue:competionId];
    if (competition) {
        if (complete) {
            complete(competition, nil);
        }
    }
    else {
        __weak typeof(self) weakSelf = self;
        AVQuery *query = [TJCompetition query];
        [query whereKey:@"competitionId" equalTo:competionId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
            if (error) {
                if (complete) {
                    complete(nil,error);
                }
            }else{
                if (results.count > 0) {
                    results = [weakSelf insertCompetitionsWithArray:results];
                    if (complete) {
                        complete(results.firstObject, nil);
                    }
                } else {
                    if (complete) {
                        complete(nil, [[NSError alloc] init]);
                    }
                }
            }
        }];
    }
}

- (void)getEarlierCompetitionsFromNetwork:(NSNumber *)competitionId withType:(NSNumber *)type limit:(int)limit complete:(void (^)(NSArray *, NSError *))complete
{
    __weak typeof(self) weakSelf = self;
    AVQuery *query = [TJCompetition query];
    [query whereKey:@"type" equalTo:type];
    [query whereKey:@"competitionId" lessThan:competitionId];
    query.limit = limit;
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (error){
            complete(nil, error);
        }else{
            results=[weakSelf insertCompetitionsWithArray:results];
            complete(results, nil);
        }
    }];
}

- (void)getLatestCompetitionsFromNetworkWithType:(NSNumber *)type limit:(int)limit complete:(void (^)(NSArray *, NSError *))complete
{
    [self getEarlierCompetitionsFromNetwork:@(1 << 30) withType:type limit:limit complete:complete];
}

@end
