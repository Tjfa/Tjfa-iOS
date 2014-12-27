//
//  AboutManager.m
//  Tjfa
//
//  Created by 邱峰 on 7/10/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "AboutManager.h"
#import "DatabaseManager.h"
#import "UIDevice+DeviceInfo.h"
#import "AppInfo.h"
#import "MBProgressHUD+AppProgressView.h"
#import "RennShareComponent.h"
#import <MessageUI/MessageUI.h>
#import <WXApi.h>

@interface AboutManager () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIActionSheetDelegate>

@end

@implementation AboutManager

#pragma mark - suggestion and rate

+ (AboutManager*)sharedAboutManager
{
    static AboutManager* _sharedAboutManager = nil;
    static dispatch_once_t aboutManagerToken;
    dispatch_once(&aboutManagerToken, ^() {
        _sharedAboutManager=[[AboutManager alloc] init];
    });
    return _sharedAboutManager;
}

- (void)gotoSuggestion
{
    [self sendEmail];
}

- (void)sendEmail
{
    MFMailComposeViewController* mail = [[MFMailComposeViewController alloc] init];
    mail.mailComposeDelegate = (id)self;

    if ([MFMailComposeViewController canSendMail]) {
        //设置收件人
        [mail setToRecipients:@[ @"tongjizuxie@gmail.com" ]];

        //设置抄送人
        //[mail setCcRecipients:ccAddress];
        //设置邮件内容
        [mail setMessageBody:[NSString stringWithFormat:@"%@\n请在分割线下面写下您的建议，或者遇到的问题:\n\n-------------------------------------------\n\n", [UIDevice deviceInfo]] isHTML:NO];
        NSLog(@"%@", [UIDevice deviceInfo]);
        //设置邮件主题
        [mail setSubject:@"TJFA建议"];

        [self.instanceController presentViewController:mail animated:YES completion:nil];
    } else {
        [self sendEmailFail:@"您的设备不支持邮件发送，检查是否设置了邮件账户。如果一切正常，建议您更新设备"];
    }
}

- (void)sendEmailFail:(NSString*)errorMessage
{
    if (errorMessage == nil) {
        errorMessage = @"对不起，邮件发送失败，检查网络或者您的设备是否正常";
    }
    UIAlertView* view = [[UIAlertView alloc] initWithTitle:@"发送失败" message:errorMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [view show];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"谢谢您的参与" message:@"再次感谢您为我们提出的意见，我们会尽早处理您的反馈" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    switch (result) {
    case MFMailComposeResultCancelled:
        NSLog(@"取消发送mail");
        break;
    case MFMailComposeResultSaved:
        NSLog(@"保存邮件");
        break;
    case MFMailComposeResultSent:
        NSLog(@"发送邮件");
        [alert show];
        break;
    case MFMailComposeResultFailed:
        NSLog(@"邮件发送失败: %@...", [error localizedDescription]);
        [self sendEmailFail:nil];
        break;
    default:
        break;
    }
    [self.instanceController dismissViewControllerAnimated:YES completion:nil];
}

- (void)evaluate
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[AppInfo appDownloadAddress]]];
}

#pragma mark - delete local data

- (void)deleteLocalData
{
    if (self.instanceController == nil)
        return;

    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"童鞋。。你要知道你在做什么" delegate:self cancelButtonTitle:@"好吧。。我错了" destructiveButtonTitle:@"别拦我。。我流量多。。" otherButtonTitles:nil, nil];
    [actionSheet showInView:self.instanceController.view];
}

#pragma mark - UIActionSheet delegete

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        MBProgressHUD* mbProgressHub = [[MBProgressHUD alloc] initWithView:self.instanceController.navigationController.view];
        [self.instanceController.navigationController.view addSubview:mbProgressHub];
        mbProgressHub.dimBackground = YES;
        mbProgressHub.labelText = @"清除中。。请稍候";

        __weak AboutManager* weakSelf = self;

        [mbProgressHub showAnimated:YES whileExecutingBlock:^(void) {
            dispatch_async(dispatch_get_main_queue(), ^(){
                [[DatabaseManager sharedDatabaseManager] clearAllData];
            });
        } completionBlock:^() {
            
            MBProgressHUD* finishProgress=[[MBProgressHUD alloc] initWithView:weakSelf.instanceController.navigationController.view];
            [weakSelf.instanceController.navigationController.view addSubview:finishProgress];
            finishProgress.dimBackground = YES;
            finishProgress.labelText = @"清除成功";
            finishProgress.mode= MBProgressHUDModeCustomView;
            finishProgress.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkMark"]];
            [finishProgress showAnimated:YES whileExecutingBlock:^(){
                sleep(1);
            }];
        }];
    }
}

#pragma mark - shared

- (void)sharedWithMessage
{
    MFMessageComposeViewController* message = [[MFMessageComposeViewController alloc] init];
    message.messageComposeDelegate = (id)self;
    if ([MFMessageComposeViewController canSendText]) {
        message.body = [AppInfo sharedMessage];
        [self.instanceController presentViewController:message animated:YES completion:nil];
    } else {
        [self sendEmailFail:@"您的设备不支持信息发送，检查是否设置了iCloud账户。如果一切正常，建议您更新设备"];
    }
}

- (void)sharedWithWeiXin
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = [AppInfo sharedMessage];
    req.bText = YES;
    req.scene = WXSceneTimeline;

    [WXApi sendReq:req];
}

- (void)sharedWithRenRen
{

    RennTextMessage *textMessage = [[RennTextMessage alloc] init];
    textMessage.url = @"http://www.lazyclutch.com";
    textMessage.title = @"快来下载同济足协iOS版app";
    textMessage.text = [NSString stringWithFormat:@"hi~~我亲爱的小伙伴～～我发现了关于同济足球的一个很棒的App,叫做\"%@\",现在已经升级到%@版本了,快去看看吧～～", [AppInfo appName], [AppInfo appVersion]];
    NSInteger errCode = [RennShareComponent SendMessage:textMessage msgTarget:To_Renren];
    NSLog(@"%ld",errCode);
}

- (void)messageComposeViewController:(MFMessageComposeViewController*)controller didFinishWithResult:(MessageComposeResult)result
{
    [self.instanceController dismissViewControllerAnimated:YES completion:nil];
}

@end
