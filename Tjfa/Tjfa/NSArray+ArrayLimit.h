//
//  NSArray+ArrayLimit.h
//  Tjfa
//
//  Created by 邱峰 on 6/27/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ArrayLimit)

/**
 *  返回array中的前limit个元素
 *
 *  @param limit 返回array的个数
 *
 *  @return new array
 */
- (NSArray*)arrayWithLimit:(int)limit;

@end
