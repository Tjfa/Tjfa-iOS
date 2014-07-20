//
//  UIViewController+Identifier.h
//  Tjfa
//
//  Created by 邱峰 on 7/17/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Identifier)

+ (NSString*)matchViewControllerIdentifier;

+ (NSString*)menuViewControllerIdentifier;

+ (NSString*)scoreListViewControllerIdentifier;

+ (NSString*)yellowCardViewControllerIdentifier;

+ (NSString*)redCardViewControllerIdentifier;

+ (NSString*)groupScoreViewController;

+ (NSString*)teamViewController;
@end
