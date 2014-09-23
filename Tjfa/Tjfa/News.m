//
//  News.m
//  Tjfa
//
//  Created by 邱峰 on 6/27/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "News.h"
#import "NSDate+Date2Str.h"
#import "AVNews.h"
#import <CoreData+MagicalRecord.h>

@implementation News

@dynamic content;
@dynamic date;
@dynamic newsId;
@dynamic title;
@dynamic isRead;
@dynamic precontent;

- (NSString*)description
{
    NSDictionary* dictionary = @{ @"newsId" : self.newsId,
                                  @"precontent" : self.precontent,
                                  @"content" : self.content,
                                  @"date" : self.date ,
                                  @"title":self.title};
    return [dictionary description];
}

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
