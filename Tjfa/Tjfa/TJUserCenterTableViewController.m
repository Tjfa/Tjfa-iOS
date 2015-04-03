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

@interface TJUserCenterTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) TJUser *user;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@end

const int avatar_index = 0;

@implementation TJUserCenterTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.user = [TJUser currentUser];
    if (self.user.avatar) {
        NSData *data = [self.user.avatar getData];
        [self.avatarImageView setImage:[UIImage imageWithData:data]];
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
            loading.progress = percentDone / 100.0 * 99.0;
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
