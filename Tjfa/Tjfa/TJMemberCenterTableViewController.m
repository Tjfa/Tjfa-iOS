//
//  TJMemberCenterTableViewController.m
//  Tjfa
//
//  Created by 邱峰 on 4/7/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJMemberCenterTableViewController.h"
#import "TJVCFFileManager.h"
#import "MBProgressHUD+AppProgressView.h"
#import "TJUserManager.h"

@interface TJMemberCenterTableViewController ()

@end

@implementation TJMemberCenterTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    
}

- (void)getUser
{
    if (!self.targerUser) {
        self.tableView.hidden = YES;
        self.tableView.hidden = YES;
        MBProgressHUD *loading = [MBProgressHUD progressHUDNetworkLoadingInView:nil withText:nil];
        [[TJUserManager sharedUserManager] findUserWithAccount:self.userAccount complete:^(TJUser *user, NSError *error) {
            [loading hide:YES];
            if (error) {
                [MBProgressHUD showErrorProgressInView:nil withText:@"未找到用户"];
            }
            else {
                self.targerUser = user;
                self.tableView.hidden = NO;
            }
        }];
    }
}

#pragma mark - Share

- (IBAction)shareMemberPress:(UIButton *)sender
{
    NSString *str = [TJVCFFileManager generalVCFStringWithUser:self.targerUser];
}

- (IBAction)sendMessagePress:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",self.targerUser.mobilePhoneNumber]]];
}

- (IBAction)callPhonePress:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.targerUser.mobilePhoneNumber]]];
}

@end
