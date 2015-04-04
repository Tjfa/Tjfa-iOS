//
//  EMConversation+LoadMessage.m
//  Tjfa
//
//  Created by 邱峰 on 4/3/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "EMConversation+LoadMessage.h"
#import <EaseMob.h>

@implementation EMConversation (LoadMessage)

- (NSArray *)loadNumbersOfMessages:(NSUInteger)count
{
    NSDate *date = [NSDate date];
    long long timestamp = [date timeIntervalSince1970] * 1000;
    return [self loadNumbersOfMessages:count before:timestamp];
}

- (NSArray *)loadNumbersOfMessages:(NSUInteger)count beforeMessage:(EMMessage *)message
{
    if (message) {
        return [self loadNumbersOfMessages:count before:message.timestamp];
    }
    else {
        return [self loadNumbersOfMessages:count];
    }
}

- (void)ayncLoadNumberOfMessages:(NSUInteger)count complete:(void (^)(NSArray *))complete
{
    dispatch_async(dispatch_queue_create("EMConversation+LoadMessage", nil), ^() {
        NSArray *messages = [self loadNumbersOfMessages:count];
        if (complete) {
            complete(messages);
        }
    });
}

- (void)ayncLoadNumberOfMessages:(NSUInteger)count before:(EMMessage *)message complete:(void (^)(NSArray *))complete
{
    dispatch_async(dispatch_queue_create("EMConversation+LoadMessage", nil), ^() {
        NSArray *messages = [self loadNumbersOfMessages:count beforeMessage:message];
        if (complete) {
            complete(messages);
        }
    });
}

@end
