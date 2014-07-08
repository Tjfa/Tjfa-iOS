//
//  AboutProjectViewController.m
//  Tjfa
//
//  Created by 邱峰 on 6/29/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "AboutProjectViewController.h"
#import <MessageUI/MessageUI.h>
#import "UIDevice+DeviceInfo.h"
#import <MBProgressHUD.h>
#import "DatabaseManager.h"
#import "AppInfo.h"

@interface AboutProjectViewController () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIActionSheetDelegate>

@end

@implementation AboutProjectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"为我评分"]) {
        [self evaluate];
    } else if ([cell.textLabel.text isEqualToString:@"问题与反馈"]) {
        [self gotoSuggestion];
    } else if ([cell.textLabel.text isEqualToString:@"删除本地数据"]) {
        [self deleteLocalData];
    } else if ([cell.textLabel.text isEqualToString:@"告诉朋友"]) {
        [self sharedWithMessage];
    }
}

#pragma mark - suggestion and rate

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

        //设置邮件主题
        [mail setSubject:@"TJFA建议"];

        [self presentViewController:mail animated:YES completion:nil];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)evaluate
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[AppInfo appDownloadAddress]]];
}

#pragma mark - delete local data

- (void)deleteLocalData
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"童鞋。。你要知道你在做什么" delegate:self cancelButtonTitle:@"好吧。。我错了" destructiveButtonTitle:@"别拦我。。我流量多。。" otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheet delegete

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        MBProgressHUD* mbProgressHub = [[MBProgressHUD alloc] initWithView:self.parentViewController.view.superview.superview];
        [self.parentViewController.parentViewController.view addSubview:mbProgressHub];
        mbProgressHub.dimBackground = YES;
        mbProgressHub.labelText = @"清除中。。请稍候";

        __weak AboutProjectViewController* weakSelf = self;
        [mbProgressHub showAnimated:YES whileExecutingBlock:^(void) {
            [[DatabaseManager sharedDatabaseManager] clearAllData];
        } completionBlock:^() {
            
            MBProgressHUD* finishProgress=[[MBProgressHUD alloc] initWithView:self.parentViewController.view.superview.superview];
            [weakSelf.parentViewController.parentViewController.view addSubview:finishProgress];
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
        message.body = [NSString stringWithFormat:@"hi~~我发现了一个关于同济足球的一个很棒的app,叫做%@,地址在%@,快去下载吧～～", [AppInfo appName], [AppInfo appDownloadAddress]];
        [self presentViewController:message animated:YES completion:nil];
    } else {
        [self sendEmailFail:@"您的设备不支持信息发送，检查是否设置了iCloud账户。如果一切正常，建议您更新设备"];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController*)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
