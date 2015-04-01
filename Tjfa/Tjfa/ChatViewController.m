//
//  ChatViewController.m
//  Tjfa
//
//  Created by 邱峰 on 3/31/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "ChatViewController.h"
#import "TJModule.h"
#import "MBProgressHUD+AppProgressView.h"

@interface ChatViewController()<EMChatManagerDelegate>

@property (nonatomic, strong) TJUser *currentUser;

@property (nonatomic, strong) EMConversation *conversation;

@property (nonatomic, strong) MBProgressHUD *loadingView;

@end

@implementation ChatViewController

+ (id)allocWithRouterParams:(NSDictionary *)params
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    id instance = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    return instance;
}



- (void)viewDidLoad
{
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
    
    self.currentUser = [TJUser currentUser];
    BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
    if (!isAutoLogin) {
        [self.loadingView show:YES];
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:self.currentUser.username password:self.currentUser.username];
    }
    else {
        [self setupConversation];
    }
}

- (void)setupConversation
{
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    self.conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.targetEmId isGroup:self.isGroup];
}

#pragma mark - Getter & Setter

- (MBProgressHUD *)loadingView
{
    if (_loadingView == nil) {
         _loadingView = [MBProgressHUD progressHUDNetworkLoadingInView:nil withText:@"初始化中"];
    }
    return _loadingView;
}

#pragma mark - ChatManager Delegate

- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    [self.loadingView hide:YES];
    if (error) {
        NSLog(@"%@", error.description);
        [MBProgressHUD showErrorProgressInView:nil withText:@"初始化失败"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self setupConversation];
    }
}

- (void)willAutoReconnect
{
    
}

@end
