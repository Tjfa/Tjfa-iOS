//
//  NSDate+Date2Str.h
//  Tjfa
//
//  Created by 邱峰 on 14-3-26.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Date2Str)

- (NSString*)date2str;

- (NSString*)date2CompetitionStr;

/**
 *  将string转化为nsdate
 *
 *  @param str yyyy-MM-dd HH:mm:ss
 *
 *  @return the date of str
 */
+ (NSDate*)str2Date:(NSString*)str;

@end
