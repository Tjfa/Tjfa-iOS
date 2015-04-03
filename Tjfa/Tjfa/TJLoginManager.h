//
//  LoginManager.h
//  Tjfa
//
//  Created by 邱峰 on 3/31/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJLoginManager : NSObject

/**
 *  仅支持手机注册 因此 这里是一个正则表达式判断是否是可行的手机
 */
+ (BOOL)isAvailableAccount:(NSString *)account;

/**
 *  返回最小的密码长度
 */
+ (int)getMinPasswordLength;

/**
 *  如果报错 那就是密码长度不够 用getMinPasswordLength获取密码长度
 *
 *  @return 是否可行的密码
 */
+ (BOOL)isAvailablePassword:(NSString *)password;

@end
