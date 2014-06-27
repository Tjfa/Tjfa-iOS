//
//  NSArray+ArrayLimit.m
//  Tjfa
//
//  Created by 邱峰 on 6/27/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "NSArray+ArrayLimit.h"

@implementation NSArray (ArrayLimit)

- (NSArray*)arrayWithLimit:(int)limit
{

    NSMutableArray* results = [[NSMutableArray alloc] init];
    int i = 0;
    for (id obj in self) {
        if (i++ >= limit)
            break;
        [results addObject:obj];
    }
    return results;
}

@end
