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


+(CompetitionManager*) sharedCompetitionManager
{
    static CompetitionManager* _sharedCompetitionManager = nil;
    static dispatch_once_t competitionOnceToken;
    dispatch_once(&competitionOnceToken, ^{
        _sharedCompetitionManager=[[CompetitionManager alloc] init];
    });
    return _sharedCompetitionManager;
}


-(void) clearAllCompetitions
{
    NSArray* competitions=[Competition findAll];
    for (Competition* obj in competitions)
    {
        [obj deleteEntity];
    }
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}

-(void) insertCompetitionsWithArray:(NSArray*)array
{
    for (NSDictionary* obj in array)
    {
        NSInteger competitionId=[[obj objectForKey:@"id"] intValue];
        if ([Competition findFirstByAttribute:[Competition idAttributeStr] withValue:@(competitionId)]==nil)
        {
            Competition* newObj=[Competition createEntity];
            newObj.competitionID=@(competitionId);
            newObj.name=[obj objectForKey:@"name"];
            newObj.time=[obj objectForKeyedSubscript:@"time"];
            newObj.isStart=[obj objectForKey:@"isStart"];
            newObj.number=[obj objectForKey:@"number"];
            [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
        }
    }
}

-(NSArray*) getCompetitionsByDateFromCoreData:(NSString*)dateStr
{
    return [Competition findByAttribute:[Competition timeAttributeStr] withValue:dateStr andOrderBy:[Competition nameAttributeStr] ascending:YES];
}

-(void) getCompetitionsByDateFromNetwork:(NSString*)dateStr complete:(void (^)(NSArray* results,NSError* error))complete
{
    [[NetworkClient sharedNetworkClient] searchForAddress:@"Works/WorksItem.php" withParameters:@{@"workId":@"18" } complete:^(NSArray* results,NSError* error){
        
        if (error)
        {
            complete(nil,error);
        }
        else
        {
            [self insertCompetitionsWithArray:results];
            complete([Competition findByAttribute:[Competition timeAttributeStr] withValue:dateStr andOrderBy:[Competition nameAttributeStr] ascending:YES],nil);
        }
    }];
}


@end
