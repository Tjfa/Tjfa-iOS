//
//  NewAboutViewController.m
//  Tjfa
//
//  Created by 邱峰 on 7/10/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "NewAboutViewController.h"
#import "Developer.h"
#import "UIColor+AppColor.h"
#import "AboutManager.h"
#import "AppInfo.h"

@interface NewAboutViewController () <UIGestureRecognizerDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) IBOutlet UILabel* versionLable;

@property (nonatomic, strong) NSMutableArray* data;

@end

@implementation NewAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aboutBg"]];
    // Do any additional setup after loading the view.
}

- (void)getRandomArray:(NSMutableArray*)developerArray
{
    for (int i = 0; i < developerArray.count; i++) {
        int randomNum = arc4random() % developerArray.count;
        Developer* obj = developerArray[i];
        [developerArray replaceObjectAtIndex:i withObject:developerArray[randomNum]];
        [developerArray replaceObjectAtIndex:randomNum withObject:obj];
    }
}

- (NSMutableArray*)data
{
    if (_data == nil) {
        _data = [[NSMutableArray alloc] init];
        NSArray* name = @[ @"aaa", @"bb", @"ccc", @"ddd", @"xxx", @"ddd" ];
        NSArray* imageName = @[ @"dashboardNews", @"qiufeng", @"qiufeng", @"qiufeng", @"qiufeng", @"qiufeng" ];
        for (int i = 0; i < name.count; i++) {
            Developer* developer = [[Developer alloc] initWithName:name[i] imageName:imageName[i]];
            [_data addObject:developer];
        }
        [self getRandomArray:_data];
    }
    return _data;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)setVersionLable:(UILabel*)versionLable
{
    if (_versionLable != versionLable) {
        _versionLable = versionLable;
        _versionLable.text = [NSString stringWithFormat:@"V %@", [AppInfo appVersion]];
    }
}

#pragma mark - tableView delegate & select action

#define TELL_FRIEND 0
#define EVALUATE_INDEX 1
#define QUESTION 2

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == TELL_FRIEND) {
            [self shared];
        } else if (indexPath.row == QUESTION) {
            [self gotoSuggestion];
        } else if (indexPath.row == EVALUATE_INDEX) {
            [self evaluate];
        }
    } else {
        if (indexPath.row == 0) {
            [self deleteLocalData];
        }
    }
}

- (void)evaluate
{
    AboutManager* aboutManager = [AboutManager sharedAboutManager];
    aboutManager.instanceController = self;
    [aboutManager evaluate];
}

- (void)deleteLocalData
{
    AboutManager* aboutManager = [AboutManager sharedAboutManager];
    aboutManager.instanceController = self;
    [aboutManager deleteLocalData];
}

- (void)gotoSuggestion
{
    AboutManager* aboutManager = [AboutManager sharedAboutManager];
    aboutManager.instanceController = self;
    [aboutManager gotoSuggestion];
}

- (void)shared
{
    UIActionSheet* sharedActionSheet = [[UIActionSheet alloc] initWithTitle:@"我要分享" delegate:self cancelButtonTitle:@"手残。。点错了" destructiveButtonTitle:nil otherButtonTitles:@"短信分享给好友", @"微信分享到朋友圈", nil];
    [sharedActionSheet showInView:self.view];
}

- (IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - actionSheet delegate

#define MESSAGE_SHARED 0
#define WEIXIN_SHARED 1
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == WEIXIN_SHARED) {
        [self sharedWithWeiXin];
    } else if (buttonIndex == MESSAGE_SHARED) {
        [self sharedWithMessage];
    }
}

- (void)sharedWithMessage
{
    AboutManager* aboutManager = [AboutManager sharedAboutManager];
    aboutManager.instanceController = self;
    [aboutManager sharedWithMessage];
}

- (void)sharedWithWeiXin
{
    AboutManager* aboutManager = [AboutManager sharedAboutManager];
    aboutManager.instanceController = self;
    [aboutManager sharedWithWeiXin];
}

@end
