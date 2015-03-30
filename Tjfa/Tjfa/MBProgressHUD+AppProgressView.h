//
//  MBProgressHUD+AppProgressView.h
//  Tjfa
//
//  Created by 邱峰 on 7/8/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (AppProgressView)

+ (MBProgressHUD*)progressHUDNetworkLoadingInView:(UIView*)view;

+ (void)showWhenNetworkErrorInView:(UIView*)view;

+ (void)showErrorProgressInView:(UIView *)view withText:(NSString *)text;

+ (void)showSucessProgressInView:(UIView *)view withText:(NSString *)text;

@end
