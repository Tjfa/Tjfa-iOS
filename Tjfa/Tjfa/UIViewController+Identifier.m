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

+ (NSString*)scoreListViewControllerIdentifier
{
    return @"ScoreListViewController";
}

+ (NSString*)yellowCardViewControllerIdentifier
{
    return @"YellowCardViewController";
}

+ (NSString*)redCardViewControllerIdentifier
{
    return @"RedCardViewController";
}

+ (NSString*)groupScoreViewController
{
    return @"GroupScoreViewController";
}

+ (NSString*)teamViewController
{
    return @"TeamViewController";
}

@end
