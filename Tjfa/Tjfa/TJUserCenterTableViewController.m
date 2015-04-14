//
//  UserCenterTableViewController.m
//  Tjfa
//
//  Created by 邱峰 on 3/31/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJUserCenterTableViewController.h"
#import "TJModule.h"
#import <UIAlertView+BlocksKit.h>
#import <UIActionSheet+BlocksKit.h>
#import "MBProgressHUD+AppProgressView.h"
#import "TJUserManager.h"

@interface TJUserCenterTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) TJUser *user;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

const int avatar_index = 0;
const int name_index = 1;
const int password_index = 2;

@implementation TJUserCenterTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.user = [TJUser currentUser];
    if (self.user.avatar) {
        [self.user.avatar getDataInBackgroundWithBlock:^(NSData *data , NSError *error) {
            if (error == nil) {
                [self.avatarImageView setImage:[UIImage imageWithData:data]];
            }
        }];
    }
    
    if (self.user.name) {
        self.nameLabel.text = self.user.name;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - TableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == avatar_index) {
        [self changeAvatar];
    }
    else if (indexPath.row == name_index) {
        [self changeName];
    }
    else if (indexPath.row == password_index) {
        [self changePassword];
    }
}

- (void)changeName
{
    UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"修改名字" message:@"请使用真实姓名"];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [alertView bk_addButtonWithTitle:@"确定" handler:^(){
        
        NSString *name = [alertView textFieldAtIndex:0].text;
        
        if (![TJUserManager isAvailableName:name]) {
            [MBProgressHUD showErrorProgressInView:nil withText:@"名字不合法"];
            return ;
        }
        
        self.user.name = name;
        [self.user saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
            [MBProgressHUD showSucessProgressInView:nil withText:@"账号修改成功"];
            self.nameLabel.text = self.user.name;
        }];
    }];
    [alertView show];

}

- (void)changeAvatar
{
    UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:nil];
    [actionSheet bk_addButtonWithTitle:@"拍照" handler:^{
        [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
    }];
    [actionSheet bk_addButtonWithTitle:@"从相册选择" handler:^{
        [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    [actionSheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [actionSheet showInView:self.view];
}


- (void)changePassword
{
    UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"修改密码"];
    alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alertView textFieldAtIndex:0].secureTextEntry = YES;
    [alertView textFieldAtIndex:0].placeholder = @"原密码";
    [alertView textFieldAtIndex:1].placeholder = @"新密码";
    [alertView bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [alertView bk_addButtonWithTitle:@"确定" handler:^(){
        NSString *oldPassword = [alertView textFieldAtIndex:0].text;
        NSString *newPassword = [alertView textFieldAtIndex:1].text;
        
        if (![TJUserManager isAvailablePassword:newPassword]) {
            [MBProgressHUD showErrorProgressInView:nil withText:[NSString stringWithFormat:@"密码不足%d位",[TJUserManager getMinPasswordLength]]];
            return;
        }
        
        MBProgressHUD *loading = [MBProgressHUD progressHUDNetworkLoadingInView:nil withText:@"请稍后"];
        [self.user updatePassword:oldPassword newPassword:newPassword block:^(id object, NSError *error) {
            [loading hide:YES];
            if (error) {
                if (error.userInfo[@"NSLocalizedDescription"]) {
                     [MBProgressHUD showErrorProgressInView:nil withText:error.userInfo[@"NSLocalizedDescription"]];
                }
                else {
                    [MBProgressHUD showErrorProgressInView:nil withText:@"密码修改失败"];
                }
            }
            else {
                [MBProgressHUD showSucessProgressInView:nil withText:@"修改密码成功"];
            }
        }];
    }];
    [alertView show];

}

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{

    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];

        picker.sourceType = sourceType;
        picker.delegate = self;
        picker.allowsEditing = YES;

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self presentViewController:picker animated:YES completion:nil];
        }];
    }
    else {
        NSString *message;
        if (sourceType == UIImagePickerControllerSourceTypeCamera) {
            message = @"获取相机失败";
        }
        else {
            message = @"获取照片失败";
        }
        [UIAlertView bk_showAlertViewWithTitle:nil message:message cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
    }
}

#pragma mark - ImagePicker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^(void) {

        MBProgressHUD *loading = [MBProgressHUD determinateProgressHUDInView:nil withText:@"图片上传中"];
        
        UIImage *image = info[UIImagePickerControllerEditedImage];
        NSData *mediaData = UIImagePNGRepresentation(image);
        AVFile *avatar = [AVFile fileWithData:mediaData];
        [avatar saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
            [loading hide:YES];
            if (success) {
                self.user.avatar = avatar;
                [self.user saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
                    if (success) {
                        [self.user saveInBackground];
                        [MBProgressHUD showSucessProgressInView:nil withText:@"修改成功"];
                        [self.avatarImageView setImage:[UIImage imageWithData:mediaData]];
                    }
                    else {
                        [MBProgressHUD showErrorProgressInView:nil withText:@"修改失败"];
                    }
                }];
            }
            else {
                [MBProgressHUD showErrorProgressInView:nil withText:@"修改失败"];
            }
        } progressBlock:^(NSInteger percentDone) {
            loading.progress = percentDone / 100.0 * 99.0 / 100;
        }];

    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)logoutAction:(id)sender
{
    [TJUser logOut];
    [MBProgressHUD showSucessProgressInView:nil withText:@"登出成功"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
