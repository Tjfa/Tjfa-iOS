//
//  SingleChatViewController.m
//  Tjfa
//
//  Created by 邱峰 on 3/31/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJSingleChatViewController.h"
#import "TJModule.h"

@implementation TJSingleChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setTargetUser:(TJUser *)targetUser
{
    if (_targetUser != targetUser) {
        _targetUser = targetUser;
        self.targetEmId = targetUser.username;
        self.isGroup = NO;
    }
}

@end
