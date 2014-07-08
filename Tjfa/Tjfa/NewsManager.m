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
    static dispatch_once_t newsManagerToken;
    dispatch_once(&newsManagerToken, ^() {
        _sharedNewsManager=[[NewsManager alloc] init];
    });
    return _sharedNewsManager;
}

- (NSArray*)getNewsFromCoreData
{
    return [News MR_findAllSortedBy:[News idAttribute] ascending:NO];
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
        [results insertObject:news atIndex:0];
    }
    return results;
}

- (void)getEarlierNewsFromNetworkWithId:(NSNumber*)newsId andLimit:(int)limit complete:(void (^)(NSArray*, NSError*))complete
{
    NSDictionary* parameters = @{
        @"newsId" : newsId,
        @"limit" : @(limit),
    };

    __weak NewsManager* weakSelf = self;
    [[NetworkClient sharedNetworkClient] searchForAddress:[NetworkClient newsAddress] withParameters:parameters complete:^(NSArray* results, NSError* error) {
        if (error){
            complete(nil,error);
        }else{
            results=[weakSelf insertNewsWithArray:results];
            complete(results,error);
        }
    }];
}

- (void)getLatestNewsFromNetworkWithLimit:(int)limit complete:(void (^)(NSArray*, NSError*))complete
{
    [self getEarlierNewsFromNetworkWithId:@(-1) andLimit:limit complete:complete];
}

- (void)getNewsContentWithNews:(News*)news complete:(void (^)(News*, NSError*))complete
{
    if (news == nil)
        return;

    if (news.content == nil || [news.content isEqualToString:@""]) {
        NSDictionary* dictionary = @{ @"newId" : news.newsId };
        [[NetworkClient sharedNetworkClient] searchForAddress:[NetworkClient newsContentAddress] withParameters:dictionary complete:^(NSString* content, NSError* error) {
            if (error){
                    complete(nil,error);
            }else{
                news.content=content;
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                    complete(news,nil);
            }
        }];
    } else {
        complete(news, nil);
    }
}

- (void)markAllNewsToRead:(News*)news
{
    news.isRead = @(YES);
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)markAllNewsToRead
{
    NSArray* array = [News MR_findAll];
    for (News* news in array) {
        news.isRead = @(YES);
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

@end
