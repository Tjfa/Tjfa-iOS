//
//  MBProgressHUD+AppProgressView.m
//  Tjfa
//
//  Created by 邱峰 on 7/8/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "MBProgressHUD+AppProgressView.h"

@implementation MBProgressHUD (AppProgressView)

+ (UIView *)mainWindow
{
    NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];

    for (UIWindow *window in frontToBackWindows)
        if (window.windowLevel == UIWindowLevelNormal) {
            return window;
        }
    return nil;
}

+ (MBProgressHUD *)determinateProgressHUDInView:(UIView *)view withText:(NSString *)text
{
    if (view == nil) {
        view = [self mainWindow];
    }
    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:progress];
    if (text == nil || text.length == 0) {
        progress.labelText = @"加载中...";
    }
    else {
        progress.labelText = text;
    }

    progress.mode = MBProgressHUDModeAnnularDeterminate;
    progress.dimBackground = YES;
    [progress show:YES];
    return progress;
}

+ (MBProgressHUD *)progressHUDNetworkLoadingInView:(UIView *)view withText:(NSString *)text
{
    if (view == nil) {
        view = [self mainWindow];
    }
    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:progress];
    if (text == nil) {
        progress.labelText = @"加载中...";
    }
    else {
        progress.labelText = text;
    }
    progress.dimBackground = YES;
    [progress show:YES];

    return progress;
}

+ (MBProgressHUD *)progressHUDNetworkErrorInView:(UIView *)view withText:(NSString *)text
{
    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:view];

    progress.labelText = text;
    progress.mode = MBProgressHUDModeCustomView;
    progress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkWrong"]];

    return progress;
}

+ (void)showWhenNetworkErrorInView:(UIView *)view
{
    if (view == nil) {
        view = [self mainWindow];
    }

    MBProgressHUD *progress = [self progressHUDNetworkErrorInView:view withText:@"网络错误"];
    [view addSubview:progress];

    progress.dimBackground = YES;
    [progress showAnimated:YES whileExecutingBlock:^() {
        sleep(1);
    }];
}

+ (void)showErrorProgressInView:(UIView *)view withText:(NSString *)text
{
    if (view == nil) {
        view = [self mainWindow];
    }
    MBProgressHUD *progress = [self progressHUDNetworkErrorInView:view withText:text];
    [view addSubview:progress];
    progress.dimBackground = YES;
    [progress showAnimated:YES whileExecutingBlock:^() {
        sleep(1);
    }];
}

+ (void)showSucessProgressInView:(UIView *)view withText:(NSString *)text
{
    if (view == nil) {
        view = [self mainWindow];
    }

    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:view];
    progress.mode = MBProgressHUDModeCustomView;
    progress.dimBackground = YES;
    progress.labelText = text;
    progress.mode = MBProgressHUDModeCustomView;
    progress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkMark"]];

    [view addSubview:progress];
    [progress showAnimated:YES whileExecutingBlock:^() {
        sleep(1);
    }];
}

@end
