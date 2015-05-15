//
//  TJLocalPushNotification.h
//  Tjfa
//
//  Created by 邱峰 on 4/18/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TJMatch;

@interface TJLocalPushNotificationManager : NSObject


+ (instancetype)sharedLocalPushNotificationManager;

/**
 *  寻找在这之前是否存在已经有的比赛提醒 和比赛时间
 *
 *  @param match 根据match的match.objectId 做hash 匹配match
 *
 *  @return 如果有这个对应的match  那么返回对应的时间 如果不存在 返回nil
 */
- (NSDate *)getMatchRemindTime:(TJMatch *)match;

- (void)asyncGetMatchRemindTime:(TJMatch *)match complete:(void (^)(NSDate *date))complete;

/**
 *  添加对应比赛的提醒 会把本地原来有的match做一个覆盖
 *
 *  @param match
 *  @param date  需要提醒的时间 如果是
 *  @return 如果添加成功 返回YES 失败返回NO
        添加失败可能性：时间小于当前时间
                     YAP DATABASE  内部错误
                     match = nil
 */
- (BOOL)addMatchRemindNotification:(TJMatch *)match teamAName:(NSString *)teamA teamBName:(NSString *)teamB date:(NSDate *)date;

- (void)asyncAddMatchRemindNotification:(TJMatch *)match teamAName:(NSString *)teamA teamBName:(NSString *)teamB date:(NSDate *)date complete:(void (^)(BOOL success))complete;

/**
 *  移除对应的提醒
 *
 *  @param match
 *
 *  @return 如果添加成功 返回YES 失败返回NO
                YAP DATABASE  内部错误
                match = nil

 */
- (BOOL)removeMatchRemindNotification:(TJMatch *)match;
- (void)asyncRemoveMatchRemindNotification:(TJMatch *)match complete:(void (^)(BOOL success))complete;

//- (NSArray *)getAllRemindMatchIds;
//- (void)asyncGetAllRemindMatchIds:(void (^)(NSArray *matches))complete;

/**
 *  根据YAP DATABASE 生成对应的提醒推送
 */
- (void)setupAllLocalPushNotifications;

/**
 *  取消推送
 */
- (void)cancelAllLocalPushNotifications;

@end
