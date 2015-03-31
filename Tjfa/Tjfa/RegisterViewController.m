//
//  RegisterViewController.m
//  Tjfa
//
//  Created by 邱峰 on 3/31/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginManager.h"
#import "MBProgressHUD+AppProgressView.h"
#import <AVOSCloud.h>
#import "AVModule.h"
#import <Routable.h>

@interface RegisterViewController()
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;



@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    
}

- (void)registerSuccess
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[Routable sharedRouter] open:@"forget"];
}

#pragma mark - action

- (IBAction)registerAndLogin:(id)sender
{
    NSString *account = self.accountTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if (![LoginManager isAvailableAccount:account]) {
        [MBProgressHUD showErrorProgressInView:nil withText:@"手机号码错误"];
        [self.accountTextField becomeFirstResponder];
        return;
    }
    
    if (![LoginManager isAvailablePassword:password]) {
        [MBProgressHUD showErrorProgressInView:nil withText:[NSString stringWithFormat:@"密码最少%d位",[LoginManager getMinPasswordLength]]];
        [self.passwordTextField becomeFirstResponder];
        return;
    }
    
    TJUser *user = [TJUser user];
    user.username = account;
    user.mobilePhoneNumber = account;
    user.password = password;
    MBProgressHUD *loading = [MBProgressHUD progressHUDNetworkLoadingInView:nil];
    [user signUpInBackgroundWithBlock:^(BOOL success, NSError *error) {
        [loading hide:YES];
        if (error) {
           // NSLog(@"%@", error.description);
            NSString *errorString = error.userInfo[@"NSLocalizedDescription"];
            if (error.code == 214) {
                errorString = @"该手机号已被注册";
            }
            else {
                errorString = error.userInfo[@"NSLocalizedDescription"];
            }
            [MBProgressHUD showErrorProgressInView:nil withText:errorString];
        }
        else {
            [MBProgressHUD showSucessProgressInView:nil withText:@"注册成功"];
            [self registerSuccess];
        }
    }];
}

@end
