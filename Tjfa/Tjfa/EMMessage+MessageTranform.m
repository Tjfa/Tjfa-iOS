//
//  EMMessage+MessageTranform.m
//  Tjfa
//
//  Created by 邱峰 on 4/2/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "EMMessage+MessageTranform.h"
#import "TJUser.h"
#import <EaseMob.h>

@implementation EMMessage (MessageTranform)

+ (EMMessage *)generalMessageWithText:(NSString *)text sender:(TJUser *)sender to:(NSString *)emId isGroup:(BOOL)isGroup
{
    EMChatText *chatText = [[EMChatText alloc] initWithText:text];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:chatText];
    EMMessage *emMessage = [[EMMessage alloc] initWithReceiver:emId bodies:@[ body ]];
    emMessage.isGroup = isGroup;
    emMessage.ext = @{ @"senderDisplayName" : sender.name,
                       @"senderId" : sender.username };
    return emMessage;
}

+ (EMMessage *)generalMessageWithImage:(UIImage *)image sender:(TJUser *)sender to:(NSString *)emId isGroup:(BOOL)isGroup
{
    EMChatImage *imgChat = [[EMChatImage alloc] initWithUIImage:image displayName:@""];
    EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithChatObject:imgChat];
    
    // 生成message
    EMMessage *message = [[EMMessage alloc] initWithReceiver:emId bodies:@[body]];
    message.isGroup = isGroup; // 设置是否是群聊
    
    message.ext = @{ @"senderDisplayName" : sender.name,
                     @"senderId" : sender.username };
    
    return message;
}

@end
