//
//  UIApplication+MainNav.m
//  Tjfa
//
//  Created by 邱峰 on 7/10/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "UIApplication+MainNav.h"

@implementation UIApplication (MainNav)

+ (void)showMain
{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController* startNav = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"StartNav"];
    UIWindow* mainWindow = [UIApplication sharedApplication].windows[0];
    mainWindow.rootViewController = startNav;
}

@end
