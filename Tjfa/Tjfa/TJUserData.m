//
//  UserData.m
//  Tjfa
//
//  Created by 邱峰 on 7/10/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TJUserData.h"
#import "TJAppInfo.h"

@implementation TJUserData

+ (TJUserData *)sharedUserData
{
    static TJUserData *_sharedUserData = nil;
    static dispatch_once_t userDataToken;
    dispatch_once(&userDataToken, ^{
        _sharedUserData=[[TJUserData alloc] init];
    });
    return _sharedUserData;
}

- (BOOL)isFirstLaunch
{
    BOOL launchAlready = [[[NSUserDefaults standardUserDefaults] objectForKey:@"launchAlready"] boolValue];
    NSString *currentVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentVersion"];
    if (launchAlready == NO || ![[TJAppInfo appVersion] isEqualToString:currentVersion]) {
        [[NSUserDefaults standardUserDefaults] setObject:[TJAppInfo appVersion] forKey:@"currentVersion"];
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"launchAlready"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }

    return NO;
}

@end
