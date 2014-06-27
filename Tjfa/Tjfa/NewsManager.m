//
//  NewsManager.m
//  Tjfa
//
//  Created by 邱峰 on 6/27/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "NewsManager.h"
#import "NSArray+ArrayLimit.h"
#import "NetworkClient.h"

@implementation NewsManager

+ (NewsManager*)sharedNewsManager
{
    static NewsManager* _sharedNewsManager = nil;
    dispatch_once_t newsManagerToken;
    dispatch_once(&newsManagerToken, ^() {
        _sharedNewsManager=[[NewsManager alloc] init];
    });
    return _sharedNewsManager;
}

- (NSArray*)getNewsFromCoreData
{
    return [News MR_findAllSortedBy:[News idAttribute] ascending:YES];
}

/**
 *  将从后台获取到的json 数据更新数据库 并且返回给前台
 *
 *  @param newsArray dictionary of array
 *
 *  @return news of array
 */
- (NSArray*)insertNewsWithArray:(NSArray*)newsArray
{
    NSMutableArray* results = [[NSMutableArray alloc] init];
    for (NSDictionary* dictionary in newsArray) {
        News* news = [News updateNewsWithDictionary:dictionary];
        [results addObject:news];
    }
    return results;
}

- (void)getEarlierNewsFromNetworkWithId:(NSNumber*)newsId andLimit:(int)limit complete:(void (^)(NSArray*, NSError*))complete
{
    NSDictionary* parameters = @{
        @"newsId" : newsId,
        @"limit" : @(limit),
    };
    [[NetworkClient sharedNetworkClient] searchForAddress:@"Works/WorksItem.php" withParameters:parameters complete:^(NSArray* results, NSError* error) {
        if (error){
            complete(nil,error);
        }else{
            results=[self insertNewsWithArray:results];
            complete(results,error);
        }
    }];
}

- (void)getLatestNewsFromNetworkWithLimit:(int)limit complete:(void (^)(NSArray*, NSError*))complete
{
    [self getEarlierNewsFromNetworkWithId:@(-1) andLimit:limit complete:complete];
}

@end
