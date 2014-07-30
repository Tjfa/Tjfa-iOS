//
//  News.m
//  Tjfa
//
//  Created by 邱峰 on 6/27/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "News.h"
#import "NSDate+Date2Str.h"
#import "NSNumber+Assign.h"

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

+ (News*)updateNewsWithDictionary:(NSDictionary*)dictionary
{
    NSNumber* newsId = [NSNumber assignValue:dictionary[@"newsId"]];
    News* news = [News MR_findFirstByAttribute:[News idAttribute] withValue:newsId];
    if (news == nil) {
        news = [News MR_createEntity];
        news.isRead = @(NO);
    }
    news.newsId = newsId;
    news.date = [NSDate str2Date:dictionary[@"date"]];
    news.title = dictionary[@"title"];
    return news;
}

@end
