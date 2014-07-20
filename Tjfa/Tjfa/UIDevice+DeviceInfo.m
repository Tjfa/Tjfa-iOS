//
//  UIDevice+DeviceInfo.m
//  Tjfa
//
//  Created by 邱峰 on 6/29/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "UIDevice+DeviceInfo.h"
#import "AppInfo.h"

@implementation UIDevice (DeviceInfo)

+ (NSString*)deviceInfo
{
    UIDevice* device = [UIDevice currentDevice];
    NSDictionary* dictionary = @{ @"name" : device.name,
                                  @"systemName" : device.systemName,
                                  @"systemVersion" : device.systemVersion,
                                  @"model" : device.model,
                                  @"version" : [AppInfo appVersion] };
    return [dictionary description];
}

@end
