//
//  ForgetPasswordViewController.m
//  Tjfa
//
//  Created by 邱峰 on 3/31/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJForgetPasswordViewController.h"
#import "TJUserManager.h"
#import "MBProgressHUD+AppProgressView.h"

@interface TJForgetPasswordViewController()

@property (weak, nonatomic) IBOutlet UITextField *mobileNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *mobileCodeButton;

@end

@implementation TJForgetPasswordViewController



#pragma mark - Action 


- (IBAction)getMobileCodePress:(UIButton *)sender
{
    NSString *mobileNumber = self.mobileNumberTextField.text;
    if (![TJUserManager isAvailableAccount:mobileNumber]) {
        [MBProgressHUD showErrorProgressInView:nil withText:@"手机号码不正确"];
        return;
    }
    
    self.mobileCodeButton.enabled = NO;
    MBProgressHUD *loading = [MBProgressHUD progressHUDNetworkLoadingInView:nil withText:@"验证码发送中.."];
    
    [AVUser requestPasswordResetWithPhoneNumber:mobileNumber block:^(BOOL succeeded, NSError *error) {
        [loading hide:YES];
        self.mobileCodeButton.enabled = YES;

        if (succeeded) {
            [MBProgressHUD showSucessProgressInView:nil withText:@"验证码发送成功"];

        } else {
            [MBProgressHUD showErrorProgressInView:nil withText:@"请稍后再试"];
        }
    }];
}

- (IBAction)resetPasswordAndLoginPress:(UIButton *)sender
{
    NSString *mobileNumber = self.mobileNumberTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *code = self.mobileCodeTextField.text;
    
    if (![TJUserManager isAvailableAccount:mobileNumber]) {
        [MBProgressHUD showErrorProgressInView:nil withText:@"手机号码不正确"];
        return;
    }
    
    if (![TJUserManager isAvailablePassword:password]) {
        [MBProgressHUD showErrorProgressInView:nil withText:[NSString stringWithFormat:@"密码最少%d位", [TJUserManager getMinPasswordLength]]];
        [self.passwordTextField becomeFirstResponder];
        return;
    }
    
    MBProgressHUD *loading = [MBProgressHUD progressHUDNetworkLoadingInView:nil withText:nil];
    [AVUser resetPasswordWithSmsCode:code newPassword:password block:^(BOOL succeeded, NSError *error) {
        [loading hide:YES];
        if (succeeded) {
            MBProgressHUD *logInLoding = [MBProgressHUD progressHUDNetworkLoadingInView:nil withText:@"重新登录中"];
            
            [TJUser logInWithUsernameInBackground:mobileNumber password:password block:^(AVUser *user, NSError *error) {
                [logInLoding hide:YES];
                if (error) {
                    [MBProgressHUD showErrorProgressInView:nil withText:@"登录失败 请稍后再试"];
                }
                else {
                    [MBProgressHUD showSucessProgressInView:nil withText:@"登录成功"];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }];
            
        }
        else {
            if (error.userInfo[@"NSLocalizedDescription"]) {
                [MBProgressHUD showSucessProgressInView:nil withText:error.userInfo[@"NSLocalizedDescription"]];
            }
            else {
                [MBProgressHUD showSucessProgressInView:nil withText:@"重置密码失败"];
            }
        }
    }];

    
}


@end
