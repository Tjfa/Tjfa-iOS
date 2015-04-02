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
#import "TJMessage.h"
#import "UIColor+AppColor.h"
#import "EMMessage+MessageTranform.h"

@interface ChatViewController()<EMChatManagerDelegate, JSQMessagesCollectionViewDataSource, JSQMessagesCollectionViewDelegateFlowLayout>

@property (nonatomic, strong) TJUser *currentUser;

@property (nonatomic, strong) EMConversation *conversation;

@property (nonatomic, strong) MBProgressHUD *loadingView;

@property (nonatomic, strong) NSMutableArray *messages;

@property (nonatomic, strong) JSQMessagesBubbleImageFactory *messageBubbleImageFactory;

@property (nonatomic, strong) JSQMessagesAvatarImage *selfAvatarImage;

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
    [super viewDidLoad];
    self.currentUser = [TJUser currentUser];
    [self setupView];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    BOOL isLogin = [[EaseMob sharedInstance].chatManager isLoggedIn];
    
    if (isLogin) {
        [self setupConversation];
    }
    else {
        BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
        [self.loadingView show:YES];
        if (!isAutoLogin) {
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:self.currentUser.username password:self.currentUser.username];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
}

- (void)setupView
{
    self.automaticallyScrollsToMostRecentMessage = true;
    self.inputToolbar.contentView.rightBarButtonItem = [JSQMessagesToolbarButtonFactory defaultSendButtonItem];
    self.inputToolbar.contentView.leftBarButtonItem = [JSQMessagesToolbarButtonFactory defaultAccessoryButtonItem];
}

- (void)setupConversation
{
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

- (NSMutableArray *)messages
{
    if (_messages == nil) {
        _messages = [NSMutableArray array];
    }
    return _messages;
}

- (JSQMessagesBubbleImageFactory *)messageBubbleImageFactory
{
    if (_messageBubbleImageFactory == nil) {
        _messageBubbleImageFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    }
    return _messageBubbleImageFactory;
}

- (JSQMessagesAvatarImage *)selfAvatarImage
{
    if (_selfAvatarImage == nil) {
        UIImage *image = [UIImage imageWithData:[self.currentUser.avatar getData]];
        _selfAvatarImage = [[JSQMessagesAvatarImage alloc] initWithAvatarImage:image highlightedImage:image placeholderImage:[UIImage imageNamed:@"defaultProvide"]];
    }
    return _selfAvatarImage;
}

#pragma mark - ChatManager Delegate

- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    [self.loadingView hide:YES];
    if (error) {
        [MBProgressHUD showErrorProgressInView:nil withText:@"初始化失败"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
        [self setupConversation];
    }
}

- (void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    [self.loadingView hide:YES];
    if (error) {
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

#pragma mark - JSQMessagesCollectionViewDataSource

- (NSString *)senderDisplayName
{
    return self.currentUser.name;
}

- (NSString *)senderId
{
    return self.currentUser.name;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TJMessage *message = self.messages[indexPath.item];
    if (message.senderId == [self senderId]) {
        return self.selfAvatarImage;
    }
    else {
        return nil;
    }
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TJMessage *message = self.messages[indexPath.item];
    if (message.senderId == [self senderId]) {
        return [self.messageBubbleImageFactory outgoingMessagesBubbleImageWithColor:[UIColor appRedColor]];
    }
    else {
        return [self.messageBubbleImageFactory incomingMessagesBubbleImageWithColor:[UIColor appGrayColor]];
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.messages[indexPath.item];
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}


- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    TJMessage *message = self.messages[indexPath.item];
    cell.textView.text = message.text;
    if (message.senderId == [self senderId]) {
        cell.textView.textColor = [UIColor whiteColor];
    }
    else {
        cell.textView.textColor = [UIColor blackColor];
    }
    
    return cell;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return [[NSAttributedString alloc] initWithString:@"cell bottom"];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return [[NSAttributedString alloc] initWithString:@"bubble top"];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
        return [[NSAttributedString alloc] initWithString:@"cell top"];
    TJMessage *message = self.messages[indexPath.item];
    if (message.senderId == [self senderId]) {
        return nil;
    }
    
    if (indexPath.item > 0) {
        TJMessage *preMessage = self.messages[indexPath.item - 1];
        if (preMessage.senderId == [self senderId]) {
            return nil;
        }
    }
}

- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date
{
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    EMMessage *emMessage = [EMMessage generalMessageWithText:text sender:self.currentUser to:self.targetEmId];
    [[EaseMob sharedInstance].chatManager asyncSendMessage:emMessage progress:nil];
    
    TJMessage *message = [TJMessage generalTJMessageWithEMMessage:emMessage];
    [self.messages addObject:message];
    [self finishSendingMessage];
    [self.collectionView reloadData];
}


@end
