//
//  NSDate+Date2Str.m
//  Tjfa
//
//  Created by 邱峰 on 14-3-26.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "NSDate+Date2Str.h"

@implementation NSDate (Date2Str)

- (NSString*)date2str
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];

    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。

    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    NSString* dateString = [dateFormatter stringFromDate:self];

    return dateString;
}

- (NSString*)date2CompetitionStr
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents* components = [calendar components:unitFlags fromDate:self];
    NSInteger curYear = [components year]; //当前的年份
    NSInteger curMonth = [components month]; //当前的月份

    if (curMonth >= 9 && curYear <= 1)
        return [NSString stringWithFormat:@"%ld1", (long)curYear]; //第一学期比赛
    else
        return [NSString stringWithFormat:@"%ld2", (long)curYear]; //第二学期比赛

    return nil;
}

@end
