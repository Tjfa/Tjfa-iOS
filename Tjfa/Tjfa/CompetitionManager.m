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
    NSArray* competitions = [Competition findAll];
    for (Competition* obj in competitions) {
        [obj deleteEntity];
    }
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}

- (NSArray*)insertCompetitionsWithArray:(NSArray*)array
{
    NSMutableArray* results = [[NSMutableArray alloc] init];
    for (NSDictionary* obj in array) {
        Competition* competition = [Competition updateBasePropertyWithDictionary:obj];
        [results addObject:competition];
    }
    return results;
}

- (NSArray*)getCompetitionsFromCoreData
{
    return [Competition findAllSortedBy:[Competition idAttributeStr] ascending:YES];
}

- (void)getCompetitionsFromNetwork:(NSString*)dateStr withLimit:(int)limit complete:(void (^)(NSArray* results, NSError* error))complete
{
    /**
     *  set limit default is 10
     */
    if (limit == 0)
        limit = 10;
    NSDictionary* parameterDictionary = @{ @"competitionId" : @(18),
                                           @"limit" : @(limit) };
    [[NetworkClient sharedNetworkClient] searchForAddress:@"Works/WorksItem.php" withParameters:parameterDictionary complete:^(NSArray* results, NSError* error) {
    
        if (error){
            complete(nil,error);
        }else{
            results=[self insertCompetitionsWithArray:results];
            complete(results,nil);
        }
    }];
}

@end
