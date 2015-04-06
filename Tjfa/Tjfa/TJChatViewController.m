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
#import "UIColor+AppColor.h"
#import <UIActionSheet+BlocksKit.h>
#import <UIAlertView+BlocksKit.h>

const int kDefaultMessageCount = 20;

@interface TJChatViewController () <EMChatManagerDelegate, JSQMessagesCollectionViewDataSource, JSQMessagesCollectionViewDelegateFlowLayout, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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
    self.collectionView.collectionViewLayout.springinessEnabled = NO;
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
    [[EaseMob sharedInstance].chatManager enableDeliveryNotification];
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

#pragma mark - TJMessage

- (TJMessage *)findTJMessageWithEMMessage:(EMMessage *)emMessage
{
    for (TJMessage *tjMessage in self.messages) {
        if ([tjMessage.emMessage.messageId isEqualToString:emMessage.messageId]) {
            return tjMessage;
        }
    }
    return nil;
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
    if (tjMessage == nil) {
        return;
    }
    
    [self.messages addObject:tjMessage];
    [self finishReceivingMessage];
}

- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages
{
    NSArray *messages = [TJMessage generalTJMessagesWithEMMessages:offlineMessages];
    [self.messages addObjectsFromArray:messages];
    [self finishReceivingMessage];
}

// 当收到图片或视频时，SDK会自动下载缩略图，并回调该方法，如果下载失败，可以通过
// asyncFetchMessageThumbnail:progress 方法主动获取
-(void)didFetchMessageThumbnail:(EMMessage *)aMessage error:(EMError *)error
{
    TJMessage *tjMessage = [self findTJMessageWithEMMessage:aMessage];
    if (tjMessage) {
        [tjMessage updateMessageWithEMMessage:aMessage withError:error];
        [self finishReceivingMessage];
    }
}

- (void)willAutoReconnect
{
}

- (void)didSendMessage:(EMMessage *)message error:(EMError *)error
{
    [self finishSendingMessage];
}

- (void)didReceiveHasReadResponse:(EMReceipt *)resp
{
    [self.collectionView reloadData];
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
    TJMessage * tjMessage = self.messages[indexPath.item];
    if (tjMessage.isMediaMessage) {
        if ( [tjMessage.media isKindOfClass:[JSQPhotoMediaItem class]]) {
            JSQPhotoMediaItem *photoMedia = (JSQPhotoMediaItem *)tjMessage.media;
            photoMedia.appliesMediaViewMaskAsOutgoing =  [tjMessage.senderId isEqualToString:[self senderId ]] ? YES : NO;
        }
    }
    return tjMessage;
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

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    TJMessage * tjMessage = self.messages[indexPath.item];
    if ([tjMessage.senderId isEqualToString:[self senderId]]) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    else {
        return 0;
    }
}


- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    TJMessage *message = self.messages[indexPath.item];
    EMMessage *emMessage = message.emMessage;
    
    if ([message.senderId isEqualToString:self.senderId]) {
        switch (emMessage.deliveryState) {
            case eMessageDeliveryState_Pending:
                return [[NSAttributedString alloc] initWithString:@"等待中" attributes:nil];
            case eMessageDeliveryState_Delivering:
                return [[NSAttributedString alloc] initWithString:@"发送中" attributes:nil];
            case eMessageDeliveryState_Failure:
                return [[NSAttributedString alloc] initWithString:@"发送失败" attributes:@{NSForegroundColorAttributeName: [UIColor appRedColor]}];
            case eMessageDeliveryState_Delivered:
            {
                if (emMessage.isDeliveredAcked) {
                    return [[NSAttributedString alloc] initWithString:@"已 读" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
                }
                else {
                    return [[NSAttributedString alloc] initWithString:@"已发送" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
                }
            }
            default:
                break;
        }
    }
    else {
        return nil;
    }
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
            return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
        }
        else {
            return nil;
        }
    }
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];

    TJMessage *message = self.messages[indexPath.item];
    
    if (! message.isMediaMessage) {
        cell.textView.text = message.text;
        if ([message.senderId isEqualToString:[self senderId]]) {
            cell.textView.textColor = [UIColor whiteColor];
        }
        else {
            cell.textView.textColor = [UIColor blackColor];
        }
    }
    else {
    }
    return cell;
}

- (void)didPressSendButtonWithText:(NSString *)text
{
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    EMMessage *emMessage = [EMMessage generalMessageWithText:text sender:self.currentUser to:self.targetEmId isGroup:self.isGroup];
    TJMessage *message = [TJMessage generalTJMessageWithEMMessage:emMessage];
    if (message == nil) {
        [self finishSendingMessage];
        return;
    }
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
    UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:nil];
    [actionSheet bk_addButtonWithTitle:@"拍照" handler:^{
        [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
    }];
    [actionSheet bk_addButtonWithTitle:@"从相册选择" handler:^{
        [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    [actionSheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [actionSheet showInView:self.view];

}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    TJMessage *tjMessage = self.messages[indexPath.item];
    if (tjMessage) {
        if (tjMessage.emMessage.deliveryState == eMessageDeliveryState_Failure) {
            UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:nil];
            [actionSheet bk_addButtonWithTitle:@"再次发送" handler:^{
                [[EaseMob sharedInstance].chatManager asyncSendMessage:tjMessage.emMessage progress:nil];
                [self.collectionView reloadData];
            }];
            [actionSheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
            [actionSheet showInView:self.view];
        }
    }
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

#pragma mark - Accessory 

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.sourceType = sourceType;
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self presentViewController:picker animated:YES completion:nil];
        }];
    }
    else {
        NSString *message;
        if (sourceType == UIImagePickerControllerSourceTypeCamera) {
            message = @"获取相机失败";
        }
        else {
            message = @"获取照片失败";
        }
        [UIAlertView bk_showAlertViewWithTitle:nil message:message cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
    }
}

#pragma mark - Image Picker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^(void) {
        UIImage *image = info[UIImagePickerControllerEditedImage];
        
        EMMessage *emMessage = [EMMessage generalMessageWithImage:image sender:self.currentUser to:self.targetEmId isGroup:self.isGroup];
        TJMessage *tjMessage = [TJMessage generalTJMessageWithEMMessage:emMessage];
        if (tjMessage) {
            /**
             *  这里环信存在一个异步bug  他把文件写入磁盘 然后是一个异步操作 我们找不到回调的方法 所以 要重新设置image
             */
            [tjMessage setPhotoMessageWithImage:image];
            
            [self.messages addObject:tjMessage];
            [[EaseMob sharedInstance].chatManager asyncSendMessage:emMessage progress:nil];
            [self finishSendingMessage];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
