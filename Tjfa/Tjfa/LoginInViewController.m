//
//  LoginInViewController.m
//  Tjfa
//
//  Created by 邱峰 on 3/30/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "LoginInViewController.h"
#import "MBProgressHUD+AppProgressView.h"
#import "LoginManager.h"
#import "TJModule.h"
#import <Routable.h>

@interface LoginInViewController() <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)login
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
    
    MBProgressHUD *loading = [MBProgressHUD progressHUDNetworkLoadingInView:nil];
    [TJUser logInWithMobilePhoneNumberInBackground:account password:password block:^(AVUser *user, NSError *error) {
        [loading hide:YES];
        if (user) {
            [MBProgressHUD showSucessProgressInView:nil withText:@"登录成功"];
            [self.navigationController popToRootViewControllerAnimated:NO];
            [[Routable sharedRouter] open:@"memberMatch"];
        }
        else {
            [MBProgressHUD showErrorProgressInView:nil withText:error.userInfo[@"NSLocalizedDescription"]];
        }
    }];
}


#pragma mark - Action

- (IBAction)loginAction:(id)sender
{
    [self login];
}

#pragma mark - TextView Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.accountTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField) {
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
