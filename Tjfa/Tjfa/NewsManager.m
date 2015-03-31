//
//  NewsManager.m
//  Tjfa
//
//  Created by 邱峰 on 6/27/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "NewsManager.h"
#import "NetworkClient.h"
#import <CoreData+MagicalRecord.h>
#import <AVOSCloud.h>
#import "TJModule.h"

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
    for (AVNews* avNews in newsArray) {
        News* news = [News updateNewsWithDictionary:avNews];
        [results insertObject:news atIndex:0];
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError* error) {
        if (error){
            NSLog(@"%@",error);
        }
    }];

    return [results sortedArrayUsingComparator:^NSComparisonResult(News* a, News* b) {
        return [b.newsId compare:a.newsId];
    }];
}

- (void)getEarlierNewsFromNetworkWithId:(NSNumber*)newsId andLimit:(int)limit complete:(void (^)(NSArray*, NSError*))complete
{
    AVQuery* query = [AVQuery queryWithClassName:@"News"];
    [query whereKey:@"newsId" lessThan:newsId];
    query.limit = limit;

    __weak typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray* results, NSError* error) {
        if (error){
            complete(nil,error);
        }else{
            NSArray* news=[weakSelf insertNewsWithArray:results];
            complete(news,error);
        }
    }];
    //    NSDictionary* parameters = @{
    //        @"newsId" : newsId,
    //        @"limit" : @(limit),
    //    };
    //    __weak NewsManager* weakSelf = self;
    //    [[NetworkClient sharedNetworkClient] searchForAddress:[NetworkClient newsAddress] withParameters:parameters complete:^(NSArray* results, NSError* error) {
    //        if (error){
    //            complete(nil,error);
    //        }else{
    //            results=[weakSelf insertNewsWithArray:results];
    //            complete(results,error);
    //        }
    //    }];
}

- (void)getNewsWithNewsId:(NSNumber *)newsId complete:(void (^)(News *news, NSError* error))complete
{
    News *news = [News MR_findFirstByAttribute:@"newsId" withValue:newsId];
    if (news) {
        if (complete) {
            complete(news, nil);
        }
    } else {
        __weak typeof(self) weakSelf = self;
        AVQuery* query = [AVQuery queryWithClassName:@"News"];
        [query whereKey:@"newsId" equalTo:newsId];
        [query findObjectsInBackgroundWithBlock:^(NSArray* results, NSError* error) {
            if (error) {
                complete(nil,error);
            } else {
                if (results.count > 0) {
                    NSArray* news=[weakSelf insertNewsWithArray:results];
                    complete(news.firstObject,error);
                } else {
                    complete(nil, [[NSError alloc] init]);
                }
            }
        }];

    }
}

- (void)getLatestNewsFromNetworkWithLimit:(int)limit complete:(void (^)(NSArray*, NSError*))complete
{
    [self getEarlierNewsFromNetworkWithId:@(1<<30) andLimit:limit complete:complete];
}

//- (void)getNewsContentWithNews:(News*)news complete:(void (^)(News*, NSError*))complete
//{
//    if (news == nil)
//        return;
//
//    if (news.content == nil || [news.content isEqualToString:@""]) {
//        NSDictionary* dictionary = @{ @"newsId" : news.newsId };
//        [[NetworkClient sharedNetworkClient] searchForAddress:[NetworkClient newsContentAddress] withParameters:dictionary complete:^(NSDictionary* content, NSError* error) {
//            if (error){
//                    complete(nil,error);
//            }else{
//                news.content=content[@"content"];
//                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
//                    complete(news,nil);
//            }
//        }];
//    } else {
//        complete(news, nil);
//    }
//}

- (void)markNewsToggleRead:(News*)news
{
    if ([news.isRead boolValue]) {
        [self markNewsToUnread:news];
    } else {
        [self markNewsToRead:news];
    }
}

- (void)markNewsToUnread:(News*)news
{
    news.isRead = @(NO);
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)markNewsToRead:(News*)news
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

- (void)clearAllNews
{
    [News MR_truncateAll];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

@end
