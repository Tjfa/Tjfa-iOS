//
//  AppInfo.h
//  Tjfa
//
//  Created by 邱峰 on 6/29/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJAppInfo : NSObject

+ (NSString *)appName;

+ (NSString *)appDownloadAddress;

+ (NSString *)appId;

+ (NSString *)appVersion;

+ (NSString *)sharedTitle;

+ (NSString *)sharedMessage;

@end
