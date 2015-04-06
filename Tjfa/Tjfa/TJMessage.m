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
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImageDownloader.h>

@implementation TJMessage

- (void)setPhotoMessageWithImage:(UIImage *)image
{
    if (self.isMediaMessage) {
        JSQPhotoMediaItem* photo = (JSQPhotoMediaItem *)self.media;
        photo.image = image;
    }
}

- (void)updateMessageWithEMMessage:(EMMessage *)emMessage withError:(EMError *)error
{
    if (error) {
        
    }
    else {
        if (self.isMediaMessage) {
            id<IEMMessageBody> msgBody = emMessage.messageBodies.firstObject;
             switch (msgBody.messageBodyType) {
                case eMessageBodyType_Image:
                {
                    EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
                    [self setPhotoMessageWithImage:[UIImage imageWithContentsOfFile:body.thumbnailLocalPath]];
                    break;
                }
                default:
                     break;
             }
        }
    }
}

+ (TJMessage *)generalTJMessageWithEMMessage:(EMMessage *)message
{
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
            EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
            

            JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:[UIImage imageWithContentsOfFile:body.thumbnailLocalPath]];
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
//        case eMessageBodyType_Video:
//        {
//            tjMessage.isVideo = YES;
//            tjMessage.isMediaMessage = YES;
//            break;
//        }
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
