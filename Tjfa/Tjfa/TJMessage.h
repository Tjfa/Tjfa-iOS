//
//  Message.h
//  Tjfa
//
//  Created by 邱峰 on 4/2/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//


#import <JSQMessagesViewController/JSQMessage.h>
#import <EMMessage.h>

@interface TJMessage : NSObject<JSQMessageData>

- (NSString *)senderId;

@property (nonatomic, strong) NSString *senderId;

@property (nonatomic, strong) NSString *senderDisplayName;

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, assign, readwrite) BOOL isMediaMessage;

@property (nonatomic, assign, readwrite) NSUInteger messageHash;

@property (nonatomic, strong, readwrite) NSString *text;

@property (nonatomic, strong) EMMessage *emMessage;

+ (TJMessage *)generalTJMessageWithEMMessage:(EMMessage *)message;

@end
