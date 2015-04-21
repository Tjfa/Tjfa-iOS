//
//  TJChatNotificationCell.m
//  Tjfa
//
//  Created by 邱峰 on 4/16/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJChatNotificationCell.h"
#import "EMMessage+MessageTranform.h"
#import "TJMessage.h"

@interface TJChatNotificationCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *message;
@end

@implementation TJChatNotificationCell

- (void)prepareForReuse
{
    
}

- (void)setCellWithEMMessage:(EMMessage *)emMessage
{
    self.nameLabel.text = emMessage.ext[@"senderDisplayName"];
    TJMessage *tjMessage = [TJMessage generalTJMessageWithEMMessage:emMessage];
    if ([tjMessage isMediaMessage]) {
        self.message.text = @"消息";
    }
    else {
        id<IEMMessageBody> msgBody = emMessage.messageBodies.firstObject;
        self.message.text = ((EMTextMessageBody *)msgBody).text;
    }
}

@end
