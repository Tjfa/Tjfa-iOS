//
//  ChatViewController.m
//  Tjfa
//
//  Created by 邱峰 on 3/31/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJChatViewController.h"
#import "TJModule.h"
#import "MBProgressHUD+AppProgressView.h"
#import "TJMessage.h"
#import "UIColor+AppColor.h"
#import "EMMessage+MessageTranform.h"
#import "EMConversation+LoadMessage.h"
#import "TJAccessoryView.h"
#import "JSQMessagesToolbarButtonFactory+VoiceButton.h"

const int kDefaultMessageCount = 20;

@interface TJChatViewController () <EMChatManagerDelegate, JSQMessagesCollectionViewDataSource, JSQMessagesCollectionViewDelegateFlowLayout, UITextViewDelegate>

@property (nonatomic, strong) TJUser *currentUser;

@property (nonatomic, strong) EMConversation *conversation;

@property (nonatomic, strong) MBProgressHUD *loadingView;

@property (nonatomic, strong) NSMutableArray *messages;

@property (nonatomic, strong) JSQMessagesBubbleImageFactory *messageBubbleImageFactory;

@property (nonatomic, strong) JSQMessagesAvatarImage *selfAvatarImage;

@property (nonatomic, strong) TJAccessoryView *accessoryView;

@end

@implementation TJChatViewController

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
    self.showLoadEarlierMessagesHeader = YES;
    self.collectionView.loadEarlierMessagesHeaderTextColor = [UIColor redColor];
}

- (void)setupView
{
    self.automaticallyScrollsToMostRecentMessage = true;
    UIButton *voiceButton = [JSQMessagesToolbarButtonFactory defaultVoiceButtonItem];
    self.inputToolbar.contentView.rightBarButtonItem = voiceButton;
    [voiceButton addTarget:self action:@selector(voiceButtonBeginRecord) forControlEvents:UIControlEventTouchDown];
    [voiceButton addTarget:self action:@selector(voiceButtonEndRecord) forControlEvents:UIControlEventTouchUpInside];
    self.inputToolbar.contentView.leftBarButtonItem = [JSQMessagesToolbarButtonFactory defaultAccessoryButtonItem];
}

- (void)setupConversation
{
    self.conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.targetEmId isGroup:self.isGroup];
    NSArray *emMessages = [self.conversation loadNumbersOfMessages:kDefaultMessageCount];
    [self.messages addObjectsFromArray:[TJMessage generalTJMessagesWithEMMessages:emMessages]];
    [self finishReceivingMessage];
    [self.loadingView hide:YES];
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
    if (error) {
        [self.loadingView hide:YES];
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
    if (error) {
        [self.loadingView hide:YES];
        [MBProgressHUD showErrorProgressInView:nil withText:@"初始化失败"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self setupConversation];
    }
}

- (void)didReceiveMessage:(EMMessage *)message
{
    TJMessage *tjMessage = [TJMessage generalTJMessageWithEMMessage:message];
    [self.messages addObject:tjMessage];
    [self finishReceivingMessage];
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
    return self.currentUser.username;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TJMessage *message = self.messages[indexPath.item];
    if ([message.senderId isEqualToString:[self senderId]]) {
        return self.selfAvatarImage;
    }
    else {
        return nil;
    }
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TJMessage *message = self.messages[indexPath.item];
    if ([message.senderId isEqualToString:[self senderId]] ) {
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

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isNeedToShowTime:indexPath]) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];

    TJMessage *message = self.messages[indexPath.item];
    cell.textView.text = message.text;
    if ([message.senderId isEqualToString:[self senderId]]) {
        cell.textView.textColor = [UIColor whiteColor];
    }
    else {
        cell.textView.textColor = [UIColor blackColor];
    }

    return cell;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    TJMessage *message = self.messages[indexPath.item];
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return [[NSAttributedString alloc] initWithString:@"bubble top"];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self isNeedToShowTime:indexPath]) {
        return nil;
    }
    else {
        TJMessage *message = self.messages[indexPath.item];
        if (message.date) {
            return [[NSAttributedString alloc] initWithString:message.date.description];
        }
        else {
            return nil;
        }
    }
}


- (void)didPressSendButtonWithText:(NSString *)text
{
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    EMMessage *emMessage = [EMMessage generalMessageWithText:text sender:self.currentUser to:self.targetEmId];
    TJMessage *message = [TJMessage generalTJMessageWithEMMessage:emMessage];
    [[EaseMob sharedInstance].chatManager asyncSendMessage:emMessage progress:nil];
    [self.messages addObject:message];
    [self finishSendingMessage];
}

/**
 *  这个方法被音效取代 所以 直接return nil
 */
- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date
{
    return ;
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"============= load earlier");
}

#pragma mark - TextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [self didPressSendButtonWithText:textView.text];
        return NO;
    }
    else {
        return YES;
        //return [super textView:textView shouldChangeTextInRange:range replacementText:text];
    }
}

#pragma mark - VoiceButton

- (void)voiceButtonBeginRecord
{
    NSLog(@"Begin Record");
}

- (void)voiceButtonEndRecord
{
    NSLog(@"END Record");
}

#pragma mark - Collection Addition Method

- (BOOL)isNeedToShowTime:(NSIndexPath *)indexPath
{
    if (indexPath.item ==  0) {
        return YES;
    }
    else {
        TJMessage *lastMessage = self.messages[indexPath.item - 1];
        TJMessage *thisMessage = self.messages[indexPath.item];
        if (thisMessage.date && lastMessage.date) {
            NSTimeInterval timestamp= [thisMessage.date timeIntervalSinceDate:lastMessage.date];
            if (timestamp > 60) {
                return YES;
            }
        }
    }
    return NO;
}

@end
