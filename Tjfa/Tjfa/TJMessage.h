//
//  Message.h
//  Tjfa
//
//  Created by 邱峰 on 4/2/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//


#import <JSQMessagesViewController/JSQMessage.h>
#import <EaseMob.h>

@interface TJMessage : JSQMessage

@property (nonatomic, strong) EMMessage *emMessage;

- (void)setPhotoMessageWithImage:(UIImage *)image;

/**
 *  在发送图片等消息后 下载完图片后 需要更新本地图片
 *
 *  @param emMessage 需要下载的图片
 *  @param error 如果下载过程中出错了 那么显示这条消息错误了
 */
- (void)updateMessageWithEMMessage:(EMMessage *)emMessage withError:(EMError *)error;

+ (TJMessage *)generalTJMessageWithEMMessage:(EMMessage *)message;

+ (NSArray *)generalTJMessagesWithEMMessages:(NSArray *)emMessages;

@end
