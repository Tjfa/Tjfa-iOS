//
//  DashboardViewController.m
//  Tjfa
//
//  Created by 邱峰 on 6/28/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TJDashboardViewController.h"
#import "TJDashboardCell.h"
#import "TJCompetitionViewController.h"
#import "UIColor+AppColor.h"
#import <Routable.h>
#import "TJUser.h"
#import <EaseMob.h>
#import "UIBarButtonItem+Badge.h"

@interface TJDashboardViewController ()

@property (nonatomic, strong) TJDashboardCell *newsView;
@property (nonatomic, strong) TJDashboardCell *settingView;
@property (nonatomic, strong) TJDashboardCell *matchView;
@property (nonatomic, strong) TJDashboardCell *memberView;

@property (nonatomic, strong) NSArray *dashBoardCellArray;

@property (nonatomic, weak) IBOutlet UIView *rootView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *notificationBarButton;

@end

@implementation TJDashboardViewController

const CGFloat dashboardButtonSize = 100;
const CGFloat labelHeight = 50;
const CGFloat delayAnimate = 0.1;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[Routable sharedRouter] setNavigationController:self.navigationController];

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashboardTitle"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateBadgeNumber];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showDashboardButtonWithSyn];
}

- (CGFloat)getBaseHeightForDashboardButton
{
    return (self.rootView.frame.size.height - dashboardButtonSize * 4) / 2;
}

- (CGFloat)offsetY
{
    return (self.rootView.frame.size.height / 2 - labelHeight - dashboardButtonSize) / 2;
}

/**
 *  同时出现
 */
- (void)showDashboardButtonWithAsyn
{
    for (TJDashboardCell *cell in self.dashBoardCellArray) {
        [cell showWithAnimateComplete:nil];
    }
}

/**
 *  按照顺序出现
 */
- (void)showDashboardButtonWithSyn
{
    for (int i = 0; i < self.dashBoardCellArray.count; i++) {
        TJDashboardCell *cell = self.dashBoardCellArray[i];
        [cell showWithAnimateAfterDelay:delayAnimate * i complete:nil];
    }
}

#pragma mark - getter & setter

- (TJDashboardCell *)matchView
{
    if (_matchView == nil) {
        CGRect cellFrame = CGRectMake(0, [self offsetY], self.rootView.frame.size.width / 2, dashboardButtonSize + labelHeight);

        _matchView = [[TJDashboardCell alloc] initWithFrame:cellFrame image:[UIImage imageNamed:@"dashboardCompetition"] labelName:@"比 赛" direction:kDashboardLabelLeft target:self action:@selector(matchClick:) dashboardSize:dashboardButtonSize];
        [self.rootView addSubview:_matchView];
    }
    return _matchView;
}

- (TJDashboardCell *)memberView
{
    if (_memberView == nil) {

        CGRect cellFrame = CGRectMake(self.rootView.frame.size.width / 2, [self offsetY], self.rootView.frame.size.width / 2, dashboardButtonSize + labelHeight);

        _memberView = [[TJDashboardCell alloc] initWithFrame:cellFrame image:[UIImage imageNamed:@"dashboardMember"] labelName:@"会 员" direction:kDashboardLabelRight target:self action:@selector(memberClick:) dashboardSize:dashboardButtonSize];
        [self.rootView addSubview:_memberView];
    }
    return _memberView;
}

- (TJDashboardCell *)newsView
{
    if (_newsView == nil) {

        CGRect cellFrame = CGRectMake(0, self.rootView.frame.size.height / 2 + [self offsetY], self.rootView.frame.size.width / 2, dashboardButtonSize + labelHeight);

        _newsView = [[TJDashboardCell alloc] initWithFrame:cellFrame image:[UIImage imageNamed:@"dashboardNews"] labelName:@"新 闻" direction:kDashboardLabelLeft target:self action:@selector(newsClick:) dashboardSize:dashboardButtonSize];
        [self.rootView addSubview:_newsView];
    }
    return _newsView;
}

- (TJDashboardCell *)settingView
{
    if (_settingView == nil) {
        CGRect cellFrame = CGRectMake(self.rootView.frame.size.width / 2, self.rootView.frame.size.height / 2 + [self offsetY], self.rootView.frame.size.width / 2, dashboardButtonSize + labelHeight);

        _settingView = [[TJDashboardCell alloc] initWithFrame:cellFrame image:[UIImage imageNamed:@"dashboardSetting"] labelName:@"设 置" direction:kDashboardLabelRight target:self action:@selector(settingClick:) dashboardSize:dashboardButtonSize];
        [self.rootView addSubview:_settingView];
    }
    return _settingView;
}

- (NSArray *)dashBoardCellArray
{
    if (_dashBoardCellArray == nil) {
        _dashBoardCellArray = [[NSArray alloc] initWithObjects:self.matchView, self.memberView, self.newsView, self.settingView, nil];
    }
    return _dashBoardCellArray;
}

#pragma mark - hide cell and push to next controller

- (void)hideWithAnimateAsynCompleteToController:(UIViewController *)controller
{
    __weak TJDashboardViewController *weakSelf = self;
    for (int i = 0; i < self.dashBoardCellArray.count; i++) {
        TJDashboardCell *cell = self.dashBoardCellArray[i];
        if (i == self.dashBoardCellArray.count - 1) {
            [cell hideWithAnimateComplete:^(BOOL finished) {
                if (finished){
                    [weakSelf.navigationController pushViewController:controller animated:YES];
                }
            }];
        }
        else {
            [cell hideWithAnimateComplete:nil];
        }
    }
}

- (void)hideWithAnimateSynCompleteToController:(NSString *)controllerMap withParams:(NSDictionary *)params
{
    for (int i = 0; i < self.dashBoardCellArray.count; i++) {
        TJDashboardCell *cell = self.dashBoardCellArray[i];
        if (i == 0) {
            [cell hideWithAnimateAfterDelay:delayAnimate * (self.dashBoardCellArray.count - i)complete:^(BOOL finished) {
                if (finished){
                    [[Routable sharedRouter] open:controllerMap withParams:params];
                }
            }];
        }
        else {
            [cell hideWithAnimateAfterDelay:delayAnimate * (self.dashBoardCellArray.count - i)complete:nil];
        }
    }
}

#pragma mark - button click

- (void)closeDashboardCellUserInterface
{
    for (TJDashboardCell *cell in self.dashBoardCellArray) {
        cell.userInteractionEnabled = NO;
    }
}

- (void)matchClick:(id)sender
{
    [self closeDashboardCellUserInterface];
    [self hideWithAnimateSynCompleteToController:@"competition" withParams:@{ @"type" : @1 }];
}

- (void)memberClick:(id)sender
{
    [self closeDashboardCellUserInterface];
    NSString *controllerId = @"login";
    if ([TJUser currentUser] != nil) {
        controllerId = @"memberMatch";
    }
    [self hideWithAnimateSynCompleteToController:controllerId withParams:nil];
}

- (void)newsClick:(id)sender
{
    [self closeDashboardCellUserInterface];
    [self hideWithAnimateSynCompleteToController:@"news" withParams:nil];
}

- (void)settingClick:(id)sender
{

    [self closeDashboardCellUserInterface];
    [self hideWithAnimateSynCompleteToController:@"setting" withParams:nil];
}

- (IBAction)pressNotificationButton:(UIBarButtonItem *)sender
{
    [self closeDashboardCellUserInterface];
    NSString *controllerId = @"login";
    if ([TJUser currentUser] != nil) {
        controllerId = @"notificationCenter";
    }
    [self hideWithAnimateSynCompleteToController:controllerId withParams:nil];
}

#pragma mark - EaseMob

- (void)updateBadgeNumber
{
    dispatch_async(dispatch_queue_create("", nil), ^() {
        NSInteger count = [[EaseMob sharedInstance].chatManager totalUnreadMessagesCount];
        dispatch_async(dispatch_get_main_queue(), ^() {
            self.navigationItem.rightBarButtonItem.badgeValue =  [NSString stringWithFormat:@"%ld", (long)count];
        });
    });
}

@end
