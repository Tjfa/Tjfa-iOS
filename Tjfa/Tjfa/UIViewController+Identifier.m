//
//  UIViewController+Identifier.m
//  Tjfa
//
//  Created by 邱峰 on 7/17/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "UIViewController+Identifier.h"

@implementation UIViewController (Identifier)

+ (NSString*)matchViewControllerIdentifier
{
    return @"MatchViewController";
}

+ (NSString*)menuViewControllerIdentifier
{
    return @"MenuViewController";
}

+ (NSString*)playerViewControllerIdentifier
{
    return @"PlayerViewController";
}

@end
