//
//  ChatViewController.h
//  Tjfa
//
//  Created by 邱峰 on 3/31/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessages.h>
#import <EaseMob.h>

extern const int kDefaultMessageCount;

@interface TJChatViewController : JSQMessagesViewController

@property (nonatomic, strong) NSString *targetEmId;

@property (nonatomic, assign) BOOL isGroup;

@end
