//
//  TJUser.m
//  Tjfa
//
//  Created by 邱峰 on 3/30/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJUser.h"

@implementation TJUser

@dynamic name;
@dynamic avatar;

+ (NSString *)parseClassName
{
    return @"_User";
}

@end
