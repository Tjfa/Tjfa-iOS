//
//  TJUserManager.m
//  Tjfa
//
//  Created by 邱峰 on 4/8/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJUserManager.h"

@implementation TJUserManager

+ (TJUserManager *)sharedUserManager
{
    static dispatch_once_t userToken;
    static TJUserManager* userManager;
    dispatch_once(&userToken, ^() {
        userManager = [[TJUserManager alloc] init];
    });
    return userManager;
}

+ (BOOL)isAvailableAccount:(NSString *)account
{
    NSRange range = [account rangeOfString:@"^1[34578]\\d{9}$" options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (int)getMinPasswordLength
{
    return 6;
}

+ (BOOL)isAvailablePassword:(NSString *)password
{
    if (password.length < [self getMinPasswordLength]) {
        return NO;
    }
    else {
        return YES;
    }
}

+ (BOOL)isAvailableName:(NSString *)name
{
    if ([name isEqualToString:@""]){
        return NO;
    }
    if ([name rangeOfString:@" "].location != NSNotFound) {
        return NO;
    }
    return YES;
}

- (void)findUserWithAccount:(NSString *)account complete:(void (^)(TJUser *, NSError *))complete
{
    AVQuery *query = [TJUser query];
    [query whereKey:@"username" equalTo:account];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (complete) {
            if (error) {
                complete(nil, error);
            }
            else {
                if (!array || array.count == 0) {
                    complete(nil, nil);
                }
                else {
                    complete(array[0], nil);
                }
            }
        }
    }];
}

- (void)getUsersWithLimit:(int)limit page:(NSInteger)page complete:(void (^)(NSArray *users, NSError* error))complete
{
    AVQuery *query = [TJUser query];
    query.limit = limit;
    query.skip = page * limit;
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (complete) {
            if (error) {
                complete(nil, error);
            }
            else {
                complete(users, nil);
            }
        }
    }];
}

- (void)searchForUserWithKey:(NSString *)key complete:(void (^)(NSArray *, NSError *))complete
{
    AVQuery *query = [TJUser query];
    query.limit = 1000;
    [query whereKey:@"name" containsString:key];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (complete) {
            if (error) {
                complete(nil, error);
            }
            else {
                complete(users, nil);
            }
        }
    }];
}

@end
