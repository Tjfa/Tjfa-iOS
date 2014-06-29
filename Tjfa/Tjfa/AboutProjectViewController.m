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

@interface AboutProjectViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation AboutProjectViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"为我评分"]) {
        [self evaluate];
    } else if ([cell.textLabel.text isEqualToString:@"问题与反馈"]) {
        [self gotoSuggestion];
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
    NSString* appid = @"";
    NSString* str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appid];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

@end
