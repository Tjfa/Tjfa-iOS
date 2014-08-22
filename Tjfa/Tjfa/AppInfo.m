//
//  AppInfo.m
//  Tjfa
//
//  Created by 邱峰 on 6/29/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "AppInfo.h"

@implementation AppInfo

+ (NSString*)appName
{
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleDisplayName"];
}

+ (NSString*)appDownloadAddress
{

    NSString* str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", [AppInfo appId]];
    return str;
}

+ (NSString*)appId
{
    NSString* appid = @"904654597";
    return appid;
}

+ (NSString*)appVersion
{
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

+ (NSString*)sharedTitle
{
    return @"同济足协出官方App啦";
}

+ (NSString*)sharedMessage
{
    return [NSString stringWithFormat:@"hi~~我亲爱的小伙伴～～我发现了关于同济足球的一个很棒的App,叫做\"%@\",现在已经升级到%@版本了,地址在%@,快去看看吧～～", [AppInfo appName], [AppInfo appVersion], [AppInfo appDownloadAddress]];
}

@end
