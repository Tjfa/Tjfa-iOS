//
//  LoginManager.m
//  Tjfa
//
//  Created by 邱峰 on 3/31/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJLoginManager.h"

@implementation TJLoginManager

+ (BOOL)isAvailableAccount:(NSString *)account
{
    NSRange range = [account rangeOfString:@"^1[34578]\\d{9}$" options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (int)getMinPasswordLength
{
    return 6;
}

+ (BOOL)isAvailablePassword:(NSString *)password
{
    if (password.length < [self getMinPasswordLength]) {
        return NO;
    }
    else {
        return YES;
    }
}

@end
