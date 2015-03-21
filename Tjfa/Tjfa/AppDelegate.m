//
//  AppDelegate.m
//  Tjfa
//
//  Created by 邱峰 on 14-3-24.
//  Copyright (c) 2014年 邱峰. All rights reserved.
//

#import "AppDelegate.h"
#import "AppInfo.h"
#import "AVCompetition.h"
#import "AVMatch.h"
#import "AVNews.h"
#import "AVPlayer.h"
#import "AVTeam.h"
#import <CoreData+MagicalRecord.h>
#import <AVOSCloud.h>
#import <AVOSCloudSNS.h>
#import <UMeng/MobClick.h>
#import "TjfaConst.h"
#import "UIDevice+DeviceInfo.h"
#import "RennShareComponent.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

#pragma mark - avoscloud
    [AVOSCloud setApplicationId:AVOS_APP_ID clientKey:AVOS_CLIENT_KEY];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [self registerAVClass];

#pragma mark - magical record
    [MagicalRecord setupCoreDataStack];

#pragma mark - weixin
    [WXApi registerApp:@"wx6cba695c52dfdeb0"];
// Override point for customization after application launch.
    
#pragma mark - renren
    [RennShareComponent initWithAppId:@"474177" apiKey:@"313e2277c5d14cee9b83441f03c5ab53" secretKey:@"313e2277c5d14cee9b83441f03c5ab53"];

#pragma mark - umeng
    
    if (DEBUG) {
        
    } else {
        [MobClick startWithAppkey:@"542396dafd98c5933102f25e"];
        [MobClick setCrashReportEnabled:YES];
    }
    
    if ([UIDevice iOSVersion] >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert| UIUserNotificationTypeBadge| UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%@", userInfo);
  
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation setObject:[UIDevice deviceName] forKey:@"deviceName"];
    [currentInstallation saveInBackground];
    
    if (DEBUG) {

    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - weixin

/**
 *  onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
 */
- (void)onReq:(BaseReq *)req
{
}

/**
 *  如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
 */
- (void)onResp:(BaseResp *)resp
{
}

#pragma mark - avos

- (void)registerAVClass
{
    [AVCompetition registerSubclass];
    [AVMatch registerSubclass];
    [AVNews registerSubclass];
    [AVPlayer registerSubclass];
    [AVTeam registerSubclass];
}

@end
