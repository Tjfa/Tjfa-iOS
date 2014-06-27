//
//  News.m
//  Tjfa
//
//  Created by 邱峰 on 14-3-25.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "News.h"
#import "NSDate+Date2Str.h"

@implementation News

@dynamic content;
@dynamic date;
@dynamic newsID;
@dynamic title;

+ (News*)updateNewsWithDictionary:(NSDictionary*)dictionary
{
    News* news = [News findFirstByAttribute:@"newsID" withValue:dictionary[@"newsID"]];
    if (news == nil) {
        news = [News createEntity];
    }
    news.newsID = dictionary[@"newsID"];
    news.date = [NSDate str2Date:dictionary[@"date"]];
    news.content = dictionary[@"content"];
    news.title = dictionary[@"title"];
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    return news;
}

@end
