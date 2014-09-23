//
//  News.m
//  Tjfa
//
//  Created by 邱峰 on 6/27/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "News.h"
#import "NSDate+Date2Str.h"
#import <CoreData+MagicalRecord.h>

@implementation News

@dynamic content;
@dynamic date;
@dynamic newsId;
@dynamic title;
@dynamic isRead;
@dynamic precontent;

+ (NSString*)idAttribute
{
    return @"newsId";
}

+ (News*)updateNewsWithDictionary:(AVNews*)avNews
{
    NSNumber* newsId = avNews.newsId;
    News* news = [News MR_findFirstByAttribute:[News idAttribute] withValue:newsId];
    if (news == nil) {
        news = [News MR_createEntity];
        news.isRead = @(NO);
    }
    news.newsId = avNews.newsId;
    news.date = avNews.date;
    news.title = avNews.title;
    news.precontent = avNews.precontent;
    news.content = avNews.content;
    return news;
}

@end
