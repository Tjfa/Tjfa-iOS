//
//  TJjsqMessagesAvatarImageManager.m
//  Tjfa
//
//  Created by 邱峰 on 4/20/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJjsqMessagesAvatarImageManager.h"
#import <JSQMessagesViewController.h>
#import <JSQMessagesAvatarImage.h>
#import "TJUser.h"

@interface TJjsqMessagesAvatarImageManager()

@property (nonatomic, strong) NSMutableDictionary *avatarDictionary;

@end

@implementation TJjsqMessagesAvatarImageManager

+ (instancetype)sharedJsqMessagesAvatarImageManager
{
    static TJjsqMessagesAvatarImageManager *manager = nil;
    static dispatch_once_t managetOnceToken;
    dispatch_once(&managetOnceToken, ^() {
        manager = [[TJjsqMessagesAvatarImageManager alloc] init];
    });
    return manager;
}

+ (JSQMessagesAvatarImage *)defaultAvatar
{
    static JSQMessagesAvatarImage *defaultAvatar = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^(){
        UIImage *image = [UIImage imageNamed:@"defaultProvide"];
        defaultAvatar = [[JSQMessagesAvatarImage alloc] initWithAvatarImage:image highlightedImage:image placeholderImage:image];
    });
    
    return defaultAvatar;
}

#pragma mark - Get 

- (NSMutableDictionary *)avatarDictionary
{
    if (_avatarDictionary == nil) {
        _avatarDictionary = [NSMutableDictionary dictionary];
    }
    return _avatarDictionary;
}

- (JSQMessagesAvatarImage *)getJSQMessagesAvatarImageWithUser:(TJUser *)user
{
    if (user == nil) {
        return nil;
    }
    
    if (self.avatarDictionary[user.objectId] !=  nil) {
        return self.avatarDictionary[user.objectId];
    }
    
    if (user.avatar) {
        [user.avatar getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error) {
                
            }
            else {
                UIImage *image = [UIImage imageWithData:data];
                JSQMessagesAvatarImage *messagesAvatar = [[JSQMessagesAvatarImage alloc] initWithAvatarImage:image highlightedImage:image placeholderImage:image];
                self.avatarDictionary[user.objectId] = messagesAvatar;
            }
        }];
    }
    return [[self class] defaultAvatar];
}


@end
