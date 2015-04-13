//
//  News.m
//  Tjfa
//
//  Created by 邱峰 on 6/27/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "News.h"
#import "NSDate+Date2Str.h"
#import "TJNews.h"
#import <CoreData+MagicalRecord.h>

@implementation News

@dynamic content;
@dynamic date;
@dynamic newsId;
@dynamic title;
@dynamic isRead;
@dynamic precontent;

- (NSString *)description
{
    NSDictionary *dictionary = @{ @"newsId" : self.newsId,
                                  @"precontent" : self.precontent,
                                  @"content" : self.content,
                                  @"date" : self.date,
                                  @"title" : self.title };
    return [dictionary description];
}

+ (NSString *)idAttribute
{
    return @"newsId";
}

+ (News *)updateNewsWithDictionary:(TJNews *)tjNews
{
    NSNumber *newsId = tjNews.newsId;
    News *news = [News MR_findFirstByAttribute:[News idAttribute] withValue:newsId];
    if (news == nil) {
        news = [News MR_createEntity];
        news.isRead = @(NO);
    }
    news.newsId = tjNews.newsId;
    news.date = tjNews.date;
    news.title = tjNews.title? tjNews.title : @"";
    news.precontent = tjNews.precontent? tjNews.precontent : @"";
    news.content = tjNews.content? tjNews.content : @"";
    return news;
}

@end
