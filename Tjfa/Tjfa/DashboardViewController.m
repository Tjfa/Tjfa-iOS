//
//  DashboardViewController.m
//  Tjfa
//
//  Created by 邱峰 on 6/28/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "DashboardViewController.h"
#import "DashboardCell.h"
#import "CompetitionViewController.h"
#import "UIColor+AppColor.h"
#import <Routable.h>
#import "TJUser.h"
#import "NotificationCenter.h"

@interface DashboardViewController ()

@property (nonatomic, strong) DashboardCell* newsView;
@property (nonatomic, strong) DashboardCell* settingView;
@property (nonatomic, strong) DashboardCell* matchView;
@property (nonatomic, strong) DashboardCell* memberView;

@property (nonatomic, strong) NSArray* dashBoardCellArray;

@property (nonatomic, weak) IBOutlet UIView* rootView;

@end

@implementation DashboardViewController

const CGFloat dashboardButtonSize = 100;
const CGFloat labelHeight = 50;
const CGFloat delayAnimate = 0.1;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[Routable sharedRouter] setNavigationController:self.navigationController];

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashboardTitle"]];

    self.navigationController.navigationBar.barTintColor = [UIColor appNavigationBarTintColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    NSDictionary* titleDictionaryAttribute = @{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont boldSystemFontOfSize:22] };
    self.navigationController.navigationBar.titleTextAttributes = titleDictionaryAttribute;
}

- (void)viewDidAppear:(BOOL)animated
{
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
    for (DashboardCell* cell in self.dashBoardCellArray) {
        [cell showWithAnimateComplete:nil];
    }
}

/**
 *  按照顺序出现
 */
- (void)showDashboardButtonWithSyn
{
    for (int i = 0; i < self.dashBoardCellArray.count; i++) {
        DashboardCell* cell = self.dashBoardCellArray[i];
        [cell showWithAnimateAfterDelay:delayAnimate * i complete:nil];
    }
}

#pragma mark - getter & setter

- (DashboardCell *)matchView
{
    if (_matchView == nil) {
        CGRect cellFrame = CGRectMake(0, [self offsetY], self.rootView.frame.size.width / 2, dashboardButtonSize + labelHeight);

        _matchView = [[DashboardCell alloc] initWithFrame:cellFrame image:[UIImage imageNamed:@"dashboardCompetition"] labelName:@"比 赛" direction:kDashboardLabelLeft target:self action:@selector(matchClick:) dashboardSize:dashboardButtonSize];
        [self.rootView addSubview:_matchView];
    }
    return _matchView;
}

- (DashboardCell *)memberView
{
    if (_memberView == nil) {

        CGRect cellFrame = CGRectMake(self.rootView.frame.size.width / 2, [self offsetY], self.rootView.frame.size.width / 2, dashboardButtonSize + labelHeight);

        _memberView = [[DashboardCell alloc] initWithFrame:cellFrame image:[UIImage imageNamed:@"dashboardMember"] labelName:@"会 员" direction:kDashboardLabelRight target:self action:@selector(memberClick:) dashboardSize:dashboardButtonSize];
        [self.rootView addSubview:_memberView];
    }
    return _memberView;
}

- (DashboardCell*)newsView
{
    if (_newsView == nil) {

        CGRect cellFrame = CGRectMake(0, self.rootView.frame.size.height / 2 + [self offsetY], self.rootView.frame.size.width / 2, dashboardButtonSize + labelHeight);

        _newsView = [[DashboardCell alloc] initWithFrame:cellFrame image:[UIImage imageNamed:@"dashboardNews"] labelName:@"新 闻" direction:kDashboardLabelLeft target:self action:@selector(newsClick:) dashboardSize:dashboardButtonSize];
        [self.rootView addSubview:_newsView];
    }
    return _newsView;
}

- (DashboardCell*)settingView
{
    if (_settingView == nil) {
        CGRect cellFrame = CGRectMake(self.rootView.frame.size.width / 2, self.rootView.frame.size.height / 2 + [self offsetY], self.rootView.frame.size.width / 2, dashboardButtonSize + labelHeight);

        _settingView = [[DashboardCell alloc] initWithFrame:cellFrame image:[UIImage imageNamed:@"dashboardSetting"] labelName:@"设 置" direction:kDashboardLabelRight target:self action:@selector(settingClick:) dashboardSize:dashboardButtonSize];
        [self.rootView addSubview:_settingView];
    }
    return _settingView;
}

- (NSArray*)dashBoardCellArray
{
    if (_dashBoardCellArray == nil) {
        _dashBoardCellArray = [[NSArray alloc] initWithObjects:self.matchView, self.memberView, self.newsView, self.settingView, nil];
    }
    return _dashBoardCellArray;
}

#pragma mark - hide cell and push to next controller

- (void)hideWithAnimateAsynCompleteToController:(UIViewController*)controller
{
    __weak DashboardViewController* weakSelf = self;
    for (int i = 0; i < self.dashBoardCellArray.count; i++) {
        DashboardCell* cell = self.dashBoardCellArray[i];
        if (i == self.dashBoardCellArray.count - 1) {
            [cell hideWithAnimateComplete:^(BOOL finished) {
                if (finished){
                    [weakSelf.navigationController pushViewController:controller animated:YES];
                }
            }];
        } else {
            [cell hideWithAnimateComplete:nil];
        }
    }
}

- (void)hideWithAnimateSynCompleteToController:(NSString *)controllerMap withParams:(NSDictionary *)params
{
    for (int i = 0; i < self.dashBoardCellArray.count; i++) {
        DashboardCell* cell = self.dashBoardCellArray[i];
        if (i == 0) {
            [cell hideWithAnimateAfterDelay:delayAnimate * (self.dashBoardCellArray.count - i)complete:^(BOOL finished) {
                if (finished){
                    [[Routable sharedRouter] open:controllerMap withParams:params];
                }
            }];
        } else {
            [cell hideWithAnimateAfterDelay:delayAnimate * (self.dashBoardCellArray.count - i)complete:nil];
        }
    }
}

#pragma mark - button click

- (void)closeDashboardCellUserInterface
{
    for (DashboardCell* cell in self.dashBoardCellArray) {
        cell.userInteractionEnabled = NO;
    }
}

- (void)matchClick:(id)sender
{
    [self closeDashboardCellUserInterface];
    [self hideWithAnimateSynCompleteToController:@"competition" withParams:@{@"type":@1}];
}

- (void)memberClick:(id)sender
{
    [self closeDashboardCellUserInterface];
    NSString *controllerId = @"login";
    if ([TJUser currentUser] != nil) {
        controllerId = @"memberHome";
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

@end
