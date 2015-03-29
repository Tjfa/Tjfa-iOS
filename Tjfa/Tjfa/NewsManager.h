//
//  NewsManager.h
//  Tjfa
//
//  Created by 邱峰 on 6/27/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "News.h"

@interface NewsManager : NSObject

+ (NewsManager*)sharedNewsManager;

/**
 *  从coredata 返回news的所有数据,用于在没有网络 活着没有刷新的情况下 存储的静态数据
 *
 *  @return array of news
 */
- (NSArray*)getNewsFromCoreData;

/**
 *  获取之前的新闻标题
 */
- (void)getEarlierNewsFromNetworkWithId:(NSNumber*)newsId andLimit:(int)limit complete:(void (^)(NSArray* results, NSError* error))complete;

/**
 *  获取最新的新闻标题
 */
- (void)getLatestNewsFromNetworkWithLimit:(int)limit complete:(void (^)(NSArray* results, NSError* error))complete;

///**
// *  暂时不考虑news更新的情况
// *
// *  @param news 传递进来一个news  这个news是可能没有content的
// *  @param complete 完成网络加载后运行的代码
// */
- (void)getNewsWithNewsId:(NSNumber *)newsId complete:(void (^)(News *news, NSError* error))complete;

/**
 *  根据新闻是否已读，如果已读 标记为未读 如果未读 标记为已读
 *
 *  @param news 传入的news
 */
- (void)markNewsToggleRead:(News*)news;

/**
 *  标记新闻为未读
 *
 *  @param 传入的新闻
 */
- (void)markNewsToUnread:(News*)news;

/**
 *  标记为已读
 *
 *  @param news 传入的新闻
 */
- (void)markNewsToRead:(News*)news;

/**
 *  标记所有新闻为已读
 */
- (void)markAllNewsToRead;

/**
 *  清楚本地news的数据
 */
- (void)clearAllNews;

@end
