//
//  News.m
//  Tjfa
//
//  Created by 邱峰 on 6/27/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "News.h"
#import "NSDate+Date2Str.h"

@implementation News

@dynamic content;
@dynamic date;
@dynamic newsId;
@dynamic title;
@dynamic isRead;

+ (NSString*)idAttribute
{
    return @"newsId";
}

+ (News*)updateNewsWithDictionary:(NSDictionary*)dictionary
{
    News* news = [News MR_findFirstByAttribute:[News idAttribute] withValue:dictionary[@"newsId"]];
    if (news == nil) {
        news = [News MR_createEntity];
        news.isRead = @(NO);
    }
    news.newsId = dictionary[@"newsId"];
    news.date = [NSDate str2Date:dictionary[@"date"]];
    news.content = dictionary[@"content"];
    news.title = dictionary[@"title"];
    return news;
}

@end
