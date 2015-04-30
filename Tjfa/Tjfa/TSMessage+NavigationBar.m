//
//  TSMessage+NavigationBar.m
//  Tjfa
//
//  Created by 邱峰 on 4/30/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TSMessage+NavigationBar.h"

@implementation TSMessage (NavigationBar)

+ (void)configTSMessage
{
    // to do here
}

+ (void)showNotificationOverNavigatonBarWithTitle:(NSString *)title subtitle:(NSString *)subtitle type:(TSMessageNotificationType)type duration:(NSTimeInterval)duration
{
    static dispatch_once_t config;
    dispatch_once(&config, ^() {
        [self configTSMessage];
    });
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [TSMessage showNotificationInViewController:window.rootViewController title:title subtitle:subtitle
                                          image:nil type:type duration:duration callback:nil buttonTitle:nil  buttonCallback:nil atPosition:TSMessageNotificationPositionNavBarOverlay canBeDismissedByUser:YES];
}




@end
