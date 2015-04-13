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
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation TJMemberCenterTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getUser];
}

- (void)getUser
{
    if (!self.targerUser) {
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
                [self setupUserInfo];
            }
        }];
    }
    else {
        [self setupUserInfo];
    }
}

- (void)setupUserInfo
{
    self.phoneLabel.text = self.targerUser.mobilePhoneNumber;
    if (self.targerUser.avatar) {
        NSData *data = [self.targerUser.avatar getData];
        [self.avatarImageView setImage:[UIImage imageWithData:data]];
    }
    
    self.nameLabel.text = self.targerUser.name;
    self.title = self.targerUser.name;

}

#pragma mark - Action

- (IBAction)shareMemberPress:(UIButton *)sender
{
    NSString *str = [TJVCFFileManager generalVCFStringWithUser:self.targerUser];
}

- (IBAction)sendMessagePress:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@",self.targerUser.mobilePhoneNumber]]];
}

- (IBAction)callPhonePress:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.targerUser.mobilePhoneNumber]]];
}

- (IBAction)copyPhoneNumberAction:(id)sender
{
    [self.phoneLabel becomeFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:self.phoneLabel.frame inView:self.phoneLabel.superview];
    [menu setMenuVisible:YES animated:YES];
}


@end