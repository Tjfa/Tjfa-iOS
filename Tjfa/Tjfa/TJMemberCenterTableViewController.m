//
//  TJMemberCenterTableViewController.m
//  Tjfa
//
//  Created by 邱峰 on 4/7/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJMemberCenterTableViewController.h"
#import "TJPersonManager.h"
#import "MBProgressHUD+AppProgressView.h"
#import "TJUserManager.h"
#import <Routable.h>

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
        [self.targerUser.avatar getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error == nil) {
                [self.avatarImageView setImage:[UIImage imageWithData:data]];
            }
        }];
    }
    
    self.nameLabel.text = self.targerUser.name;
    self.title = self.targerUser.name;

}

#pragma mark - Action

- (IBAction)shareMemberPress:(UIButton *)sender
{
    NSData *personData = [TJPersonManager generalVCFStringWithUser:self.targerUser];
    NSString *tempVcfFile = [NSTemporaryDirectory() stringByAppendingFormat:@"%@.vcf", self.targerUser.name];
    BOOL writeFileSuccess = [personData writeToFile:tempVcfFile atomically:YES];
    
    if (writeFileSuccess) {
        NSURL *fileUrl = [NSURL fileURLWithPath:tempVcfFile];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[fileUrl] applicationActivities:nil];
        [self.navigationController presentViewController:activityViewController animated:YES completion:nil];
    }
    else {
        [MBProgressHUD showErrorProgressInView:nil withText:@"生成名片失败"];
    }
}

- (IBAction)addToContact:(id)sender
{
    MBProgressHUD *progress = [MBProgressHUD progressHUDNetworkLoadingInView:nil withText:@"添加中"];
    dispatch_async(dispatch_queue_create("Add To Contact", nil), ^(){
        TJMergeCreateToContact status = [TJPersonManager mergeOrAddToContactWithUser:self.targerUser];
        dispatch_async(dispatch_get_main_queue(), ^() {
            [progress hide:YES];
            if (status == TJMergetToContact) {
                [MBProgressHUD showErrorProgressInView:nil withText:@"该联系人已存在"];
            }
            else if (status == TJMergetOrAddFail) {
                [MBProgressHUD showErrorProgressInView:nil withText:@"添加失败"];
            }
            else {
                [MBProgressHUD showErrorProgressInView:nil withText:@"添加成功"];
            }
        });
    });
 
}

- (IBAction)chatPress:(id)sender
{
    [[Routable sharedRouter] open:@"singleChat" withParams:@{@"targetEmId" : self.targerUser.username}];
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
