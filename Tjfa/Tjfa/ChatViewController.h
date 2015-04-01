//
//  ChatViewController.h
//  Tjfa
//
//  Created by 邱峰 on 3/31/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import <JSQMessagesViewController.h>
#import <EaseMob.h>

@interface ChatViewController : JSQMessagesViewController

@property (nonatomic, strong) NSString *targetEmId;

@property (nonatomic, assign) BOOL isGroup;

@end
