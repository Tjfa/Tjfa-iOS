//
//  CompetitionManager.m
//  Tjfa
//
//  Created by 邱峰 on 14-3-25.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "CompetitionManager.h"

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

-(Competition*) getCompetitionByIdFromNetwork:(int)competitionId
{
    
    return nil;
}

-(Competition*) getCompetitionByIdFromCoreData:(int)competitionId
{
    return [Competition findFirstByAttribute:[Competition IdAttributeStr] withValue:@(competitionId)] ;
}

-(Competition*) getCompetitionById:(int)competitionId
{
    Competition* competition=[self getCompetitionByIdFromCoreData:competitionId];
    if (competition==nil)
    {
        competition=[self getCompetitionByIdFromNetwork:competitionId];
    }
    return competition;
}

-(void) insertCompetitionsWithArray:(NSArray*)array
{
}

-(NSArray*) getCompetitionByDateFromCoreData:(NSDate*)date
{
    NSArray* competitionResult=[Competition findAll];
    if (result.count==0) return nil;
    for ()
}

-(NSArray*) getCompetitionsByDate:(NSDate*)date
{
    NSArray* result;
    
    
    
    return result;
}

@end
