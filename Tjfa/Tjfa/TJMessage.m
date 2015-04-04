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
    tjMessage.senderId = message.ext[@"senderId"];
    tjMessage.senderDisplayName = message.ext[@"senderDisplayName"];
    tjMessage.date = [NSDate dateWithTimeIntervalSince1970:message.timestamp / 1000];
    tjMessage.messageHash = message.messageId.hash;
    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
    tjMessage.messageBody = msgBody;
    
    switch (msgBody.messageBodyType) {
        case eMessageBodyType_Text:
        {
            tjMessage.isMediaMessage = NO;
            tjMessage.text = ((EMTextMessageBody *)msgBody).text;
            break;
        }
        case eMessageBodyType_Image:
        {
            tjMessage.isMediaMessage = YES;
            tjMessage.isImage = YES;
            break;
        }
        case eMessageBodyType_Location:
        {
            tjMessage.isMediaMessage = YES;
            tjMessage.isLocation = YES;
            break;
        }
        case eMessageBodyType_Video:
        {
            tjMessage.isVideo = YES;
            tjMessage.isMediaMessage = YES;
            break;
        }
        default:
            return nil;
    }
    return tjMessage;
}

+ (NSArray *)generalTJMessagesWithEMMessages:(NSArray *)emMessages
{
    NSMutableArray *messages = [NSMutableArray arrayWithCapacity:emMessages.count];
    for (EMMessage *message in emMessages) {
        TJMessage *tjMessage = [self generalTJMessageWithEMMessage:message];
        if (tjMessage) {
            [messages addObject:tjMessage];
        }
    }
    return messages;
}


@end
