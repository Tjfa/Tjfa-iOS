//
//  MBProgressHUD+AppProgressView.m
//  Tjfa
//
//  Created by 邱峰 on 7/8/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "MBProgressHUD+AppProgressView.h"

@implementation MBProgressHUD (AppProgressView)

+ (MBProgressHUD*)progressHUDNetworkLoadingInView:(UIView*)view
{
    MBProgressHUD* progress = [[MBProgressHUD alloc] initWithView:view];
    progress.labelText = @"加载中...";
    return progress;
}

@end
