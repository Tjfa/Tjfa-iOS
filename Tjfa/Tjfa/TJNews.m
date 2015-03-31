//
//  AVNews.m
//  Tjfa
//
//  Created by 邱峰 on 9/22/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TJNews.h"

@implementation TJNews

@dynamic content;
@dynamic date;
@dynamic newsId;
@dynamic title;
@dynamic isRead;
@dynamic precontent;

+ (NSString*)parseClassName
{
    return @"News";
}

@end
