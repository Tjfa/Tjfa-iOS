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

+ (EMMessage *)generalMessageWithText:(NSString *)text sender:(TJUser *)sender to:(NSString *)emId
{
    EMChatText *chatText = [[EMChatText alloc] initWithText:text];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:chatText];
    EMMessage *emMessage = [[EMMessage alloc] initWithReceiver:emId bodies:@[ body ]];
    emMessage.ext = @{ @"senderDisplayName" : sender.name,
                       @"senderId" : sender.username };
    return emMessage;
}

@end
