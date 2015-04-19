//
//  Message.m
//  Tjfa
//
//  Created by 邱峰 on 4/2/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJMessage.h"
#import <EaseMob.h>
#import <JSQPhotoMediaItem.h>
#import <JSQMediaItem.h>
#import <JSQLocationMediaItem.h>
#import <JSQVideoMediaItem.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImageDownloader.h>
#import "JSQVoiceMediaItem.h"

@implementation TJMessage

- (void)setPhotoMessageWithImage:(UIImage *)image
{
    if (self.isMediaMessage) {
        JSQPhotoMediaItem* photo = (JSQPhotoMediaItem *)self.media;
        photo.image = image;
    }
}

- (void)updateMessagePhotoWithFilePath:(NSString *)path
{
    [self updateMessagePhotoWithImage:[UIImage imageWithContentsOfFile:path]];
}

- (void)updateMessagePhotoWithImage:(UIImage *)image
{
    [self setPhotoMessageWithImage:image];
}

- (void)updateMessageWithEMMessage:(EMMessage *)emMessage withError:(EMError *)error
{
    if (self.isMediaMessage) {
        id<IEMMessageBody> msgBody = emMessage.messageBodies.firstObject;
        switch (msgBody.messageBodyType) {
            case eMessageBodyType_Image:
            {
                [self updateMessagePhotoWithImage:[TJMessage getImageWithEMMessage:emMessage]];
                break;
            }
            default:
                break;
        }
    }
}

+ (UIImage *)getImageWithEMMessage:(EMMessage *)message
{
    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
    if (msgBody.messageBodyType == eMessageBodyType_Image) {
        EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
        UIImage *image = [UIImage imageWithContentsOfFile:body.localPath];
        if (image == nil) {
            image = [UIImage imageWithContentsOfFile:body.thumbnailLocalPath];
        }
        return image;
    }
    else {
        return [UIImage imageNamed:@"downloadImageFail"];
    }
}

+ (NSURL *)getVoicePathWithEMMessage:(EMMessage *)message
{
    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
    if (msgBody.messageBodyType == eMessageBodyType_Voice) {
        EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
        if (body.localPath) {
            return [NSURL URLWithString:body.localPath];
        }
        else {
            return [NSURL URLWithString:body.remotePath];
        }
    }
    else {
        return nil;
    }

}

+ (TJMessage *)generalTJMessageWithEMMessage:(EMMessage *)message
{
    [[EaseMob sharedInstance].chatManager sendHasReadResponseForMessage:message];
    TJMessage *tjMessage = nil;
    NSString *senderId = message.ext[@"senderId"];
    NSString *displayName = message.ext[@"senderDisplayName"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:message.timestamp / 1000];
    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;

    switch (msgBody.messageBodyType) {
        case eMessageBodyType_Text:
        {
            tjMessage = [[TJMessage alloc] initWithSenderId:senderId senderDisplayName:displayName date:date text:((EMTextMessageBody *)msgBody).text];
            tjMessage.emMessage = message;
            break;
        }
        case eMessageBodyType_Image:
        {
            UIImage *image = [self getImageWithEMMessage:message];
            if (image == nil) {
                [[EaseMob sharedInstance].chatManager asyncFetchMessageThumbnail:message progress:nil];
            }
            JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:[self getImageWithEMMessage:message]];
            tjMessage = [[TJMessage alloc] initWithSenderId:senderId senderDisplayName:displayName date:date media:photoItem];
            tjMessage.emMessage = message;
            break;
        }
//        case eMessageBodyType_Location:
//        {
//            tjMessage.isMediaMessage = YES;
//            tjMessage.isLocation = YES;
//            break;
//        }
        case eMessageBodyType_Voice:
        {
            JSQVoiceMediaItem *vieoItem = [[JSQVoiceMediaItem alloc] initWithFileURL:[self getVoicePathWithEMMessage:message] isReadyToPlay:NO];
            tjMessage = [[TJMessage alloc] initWithSenderId:senderId senderDisplayName:displayName date:date media:vieoItem];
            tjMessage.emMessage = message;
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
