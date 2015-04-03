//
//  NSNumber+Assign.m
//  Tjfa
//
//  Created by 邱峰 on 7/29/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "NSNumber+Assign.h"

@implementation NSNumber (Assign)

+ (NSNumber *)assignValue:(id)value
{
    if ([value isKindOfClass:[NSString class]]) {
        return @([value intValue]);
    }
    else {
        return value;
    }
}

@end
