//
//  Message.m
//  Tjfa
//
//  Created by 邱峰 on 4/2/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJMessage.h"
#import <EaseMob.h>

@implementation TJMessage

+ (TJMessage *)generalTJMessageWithEMMessage:(EMMessage *)message
{
    TJMessage *tjMessage = [[TJMessage alloc] init];
    tjMessage.emMessage = message;
    tjMessage.senderId = message.from;
    tjMessage.senderDisplayName = message.ext[@"senderDisplayName"];
    tjMessage.date = [NSDate dateWithTimeIntervalSince1970:message.timestamp];
    tjMessage.isMediaMessage = NO;
    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
    tjMessage.text = ((EMTextMessageBody *)msgBody).text;
    
    return tjMessage;
}

@end
