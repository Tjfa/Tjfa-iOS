//
//  UIDevice+DeviceInfo.m
//  Tjfa
//
//  Created by 邱峰 on 6/29/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "UIDevice+DeviceInfo.h"
#import "TJAppInfo.h"

@implementation UIDevice (DeviceInfo)

+ (NSString *)deviceInfo
{
    UIDevice *device = [UIDevice currentDevice];

    /**
     *  用dictionary 转的话 在console页面显示unicode编码 在邮箱那边也是 所以 只能自己手动转
     */

    //    NSDictionary* dictionary = @{ @"name" : device.name,
    //                                  @"systemName" : device.systemName,
    //                                  @"systemVersion" : device.systemVersion,
    //                                  @"model" : device.model,
    //                                  @"version" : [AppInfo appVersion] };
    //    return [dictionary description];
    return [NSString stringWithFormat:@"{\nname : %@;\n systemName : %@;\n systemVersion : %@;\n model : %@;\n version : %@;\n}", device.name, device.systemName, device.systemVersion, device.model, [TJAppInfo appVersion]];
}

+ (float)iOSVersion
{
    return [[UIDevice currentDevice].systemVersion floatValue];
}

+ (NSString *)deviceName
{
    return [UIDevice currentDevice].name;
}

@end
