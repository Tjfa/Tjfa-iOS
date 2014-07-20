//
//  AboutProjectViewController.m
//  Tjfa
//
//  Created by 邱峰 on 6/29/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "AboutProjectViewController.h"
#import "AboutManager.h"

@interface AboutProjectViewController ()

@end

@implementation AboutProjectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"为我评分"]) {
        [self evaluate];
    } else if ([cell.textLabel.text isEqualToString:@"问题与反馈"]) {
        [self gotoSuggestion];
    } else if ([cell.textLabel.text isEqualToString:@"删除本地数据"]) {
        [self deleteLocalData];
    } else if ([cell.textLabel.text isEqualToString:@"告诉朋友"]) {
        [self sharedWithMessage];
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
    aboutManager.instanceController = self.parentViewController;
    [aboutManager deleteLocalData];
}

- (void)gotoSuggestion
{
    AboutManager* aboutManager = [AboutManager sharedAboutManager];
    aboutManager.instanceController = self;
    [aboutManager gotoSuggestion];
}

- (void)sharedWithMessage
{
    AboutManager* aboutManager = [AboutManager sharedAboutManager];
    aboutManager.instanceController = self;
    [aboutManager sharedWithMessage];
}

@end
