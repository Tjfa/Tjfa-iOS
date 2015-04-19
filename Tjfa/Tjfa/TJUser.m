//
//  TJUser.m
//  Tjfa
//
//  Created by 邱峰 on 3/30/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJUser.h"
#import <JSQMessagesViewController.h>
#import <JSQMessagesAvatarImage.h>

@implementation TJUser

@dynamic name;
@dynamic avatar;

+ (NSString *)parseClassName
{
    return @"_User";
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


- (JSQMessagesAvatarImage *)jsqMessageAvatarImage
{
    if (_jsqMessageAvatarImage == [[self class] defaultAvatar]) {
        _jsqMessageAvatarImage = nil;
    }
    
    if (_jsqMessageAvatarImage == nil) {
        
        if (self.avatar) {
            [self.avatar getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (error) {
                    _jsqMessageAvatarImage = [[self class] defaultAvatar];
                }
                else {
                    UIImage *image = [UIImage imageWithData:data];
                    _jsqMessageAvatarImage = [[JSQMessagesAvatarImage alloc] initWithAvatarImage:image highlightedImage:image placeholderImage:image];
                }
            }];
        }
        else {
            _jsqMessageAvatarImage = [[self class] defaultAvatar];
        }
        
    }
    return _jsqMessageAvatarImage;
}


@end
