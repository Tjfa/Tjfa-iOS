//
//  RegisterViewController.m
//  Tjfa
//
//  Created by 邱峰 on 3/31/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJRegisterViewController.h"
#import "TJUserManager.h"
#import "MBProgressHUD+AppProgressView.h"
#import <EaseMob.h>
#import <AVOSCloud.h>
#import "TJModule.h"
#import <Routable.h>

@interface TJRegisterViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (weak, nonatomic) IBOutlet UITextField *nameLabel;

@end

@implementation TJRegisterViewController

- (void)viewDidLoad
{
}

- (void)registerSuccess
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[Routable sharedRouter] open:@"memberMatch"];
}

#pragma mark - action

- (IBAction)registerAndLogin:(id)sender
{
    NSString *account = self.accountTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *promoCode = self.codeTextField.text.uppercaseString;
    NSString *name = [self.nameLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (![TJUserManager isAvailableAccount:account]) {
        [MBProgressHUD showErrorProgressInView:nil withText:@"手机号码错误"];
        [self.accountTextField becomeFirstResponder];
        return;
    }

    if (![TJUserManager isAvailablePassword:password]) {
        [MBProgressHUD showErrorProgressInView:nil withText:[NSString stringWithFormat:@"密码最少%d位", [TJUserManager getMinPasswordLength]]];
        [self.passwordTextField becomeFirstResponder];
        return;
    }
    
    if (name == nil || [name isEqualToString:@""]) {
        
        [self.nameLabel becomeFirstResponder];
        [MBProgressHUD showErrorProgressInView:nil withText:@"请填写真实姓名"];
        return;
    }
    
    
    MBProgressHUD *loading = [MBProgressHUD progressHUDNetworkLoadingInView:nil withText:nil];
    [AVCloud callFunctionInBackground:@"usePromocode" withParameters:@{@"codeStr" : promoCode} block:^(id object, NSError *error) {
        if (error == nil) {
            TJUser *user = [TJUser user];
            user.username = account;
            user.name = name;
            user.mobilePhoneNumber = account;
            user.password = password;
            
            
            [user signUpInBackgroundWithBlock:^(BOOL success, NSError *error) {
                [loading hide:YES];
                if (error) {
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
                    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:user.username password:user.username withCompletion:^(NSString *username, NSString *password, EMError *error) {
                        if (!error) {
                            [MBProgressHUD showSucessProgressInView:nil withText:@"注册成功"];
                            [self registerSuccess];
                            NSLog(@"注册成功");
                        }
                        else {
                            [MBProgressHUD showErrorProgressInView:nil withText:error.description];
                        }
                    } onQueue:nil];
                }
            }];
        }
        else {
            [loading hide:YES];
            [MBProgressHUD showErrorProgressInView:nil withText:@"邀请码无效"];
        }
    }];
}

#pragma mark - TextView Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.accountTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField) {
        [self.nameLabel becomeFirstResponder];
    }
    else if (textField == self.nameLabel) {
        [self.codeTextField becomeFirstResponder];
    }
    else if (textField == self.codeTextField) {
        [self.view endEditing:YES];
    }
    return YES;
}

#pragma mark - touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
