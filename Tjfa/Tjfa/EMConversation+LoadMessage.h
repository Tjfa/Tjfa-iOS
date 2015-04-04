//
//  EMConversation+LoadMessage.h
//  Tjfa
//
//  Created by 邱峰 on 4/3/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "EMConversation.h"

@interface EMConversation (LoadMessage)

/**
 *  获取历史的count条message, 同步方法
 *  如果不足count条 会返回对应的数量
 *
 *  @param count 条数限制
 *
 *  @return EMMessage 组成的Array
 */
- (NSArray *)loadNumbersOfMessages:(NSUInteger)count;

/**
 *  获取message之前的count条message, 同步方法
 *  如果不足count条 会返回对应的数量
 *
 *  @param count  条数限制
 *  @param message 请传入 EMMessage 而 不是 TJMessage
 *
 *  @return EMMessage 组成的Array
 */
- (NSArray *)loadNumbersOfMessages:(NSUInteger)count beforeMessage:(EMMessage *)message;


/**
 *  获取历史的count条message, 异步方法
 *  如果不足count条 会返回对应的数量
 *
 *  @param count 条数限制
 *  @param complete 结束的回调 EMMessage组成的array
 */
- (void)ayncLoadNumberOfMessages:(NSUInteger)count complete:( void(^)(NSArray *messages))complete;

/**
 *  获取message之前的count条message, 异步方法
 *  如果不足count条 会返回对应的数量
 *
 *  @param count    条数限制
 *  @param message  message 请传入 EMMessage 而 不是 TJMessage
 *  @param complete 结束的回调 EMMessage组成的array
 */
- (void)ayncLoadNumberOfMessages:(NSUInteger)count before:(EMMessage *)message complete:(void (^)(NSArray *))complete;

@end
