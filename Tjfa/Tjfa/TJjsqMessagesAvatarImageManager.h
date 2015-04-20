//
//  TJjsqMessagesAvatarImageManager.h
//  Tjfa
//
//  Created by 邱峰 on 4/20/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TJUser;
@class JSQMessagesAvatarImage;

@interface TJjsqMessagesAvatarImageManager : NSObject

+ (instancetype)sharedJsqMessagesAvatarImageManager;

- (JSQMessagesAvatarImage *)getJSQMessagesAvatarImageWithUser:(TJUser *)user;

@end
