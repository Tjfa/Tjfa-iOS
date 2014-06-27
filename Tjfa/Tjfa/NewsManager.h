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

- (void)getNewsFromNetworkWithId:(NSNumber*)newsId andLimit:(int)limit complete:(void (^)(NSArray* array, NSError* error))complete;
@end
