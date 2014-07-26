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

@interface DashboardViewController ()

@property (nonatomic, strong) DashboardCell* newsView;
@property (nonatomic, strong) DashboardCell* settingView;
@property (nonatomic, strong) DashboardCell* benbuView;
@property (nonatomic, strong) DashboardCell* jiadingView;

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

- (DashboardCell*)benbuButton
{
    if (_benbuView == nil) {
        CGRect cellFrame = CGRectMake(0, [self offsetY], self.rootView.frame.size.width / 2, dashboardButtonSize + labelHeight);

        _benbuView = [[DashboardCell alloc] initWithFrame:cellFrame image:[UIImage imageNamed:@"dashboardBenbu"] labelName:@"本 部" direction:kDashboardLabelLeft target:self action:@selector(benbuClick:) dashboardSize:dashboardButtonSize];
        [self.rootView addSubview:_benbuView];
    }
    return _benbuView;
}

- (DashboardCell*)jiadingButton
{
    if (_jiadingView == nil) {

        CGRect cellFrame = CGRectMake(self.rootView.frame.size.width / 2, [self offsetY], self.rootView.frame.size.width / 2, dashboardButtonSize + labelHeight);

        _jiadingView = [[DashboardCell alloc] initWithFrame:cellFrame image:[UIImage imageNamed:@"dashboardJiading"] labelName:@"嘉 定" direction:kDashboardLabelRight target:self action:@selector(jiadingClick:) dashboardSize:dashboardButtonSize];
        [self.rootView addSubview:_jiadingView];
    }
    return _jiadingView;
}

- (DashboardCell*)newsButton
{
    if (_newsView == nil) {

        CGRect cellFrame = CGRectMake(0, self.rootView.frame.size.height / 2 + [self offsetY], self.rootView.frame.size.width / 2, dashboardButtonSize + labelHeight);

        _newsView = [[DashboardCell alloc] initWithFrame:cellFrame image:[UIImage imageNamed:@"dashboardNews"] labelName:@"新 闻" direction:kDashboardLabelLeft target:self action:@selector(newsClick:) dashboardSize:dashboardButtonSize];
        [self.rootView addSubview:_newsView];
    }
    return _newsView;
}

- (DashboardCell*)settingButton
{
    if (_settingView == nil) {
        CGRect cellFrame = CGRectMake(self.rootView.frame.size.width / 2, self.rootView.frame.size.height / 2 + [self offsetY], self.rootView.frame.size.width / 2, dashboardButtonSize + labelHeight);

        _settingView = [[DashboardCell alloc] initWithFrame:cellFrame image:[UIImage imageNamed:@"dashboardSetting"] labelName:@"关 于" direction:kDashboardLabelRight target:self action:@selector(settingClick:) dashboardSize:dashboardButtonSize];
        [self.rootView addSubview:_settingView];
    }
    return _settingView;
}

- (NSArray*)dashBoardCellArray
{
    if (_dashBoardCellArray == nil) {
        _dashBoardCellArray = [[NSArray alloc] initWithObjects:self.benbuButton, self.jiadingButton, self.newsButton, self.settingButton, nil];
    }
    return _dashBoardCellArray;
}

#pragma mark - hide cell and push to next controller

- (void)hideWithAnimateAsynCompleteToController:(UIViewController*)controller
{

    for (int i = 0; i < self.dashBoardCellArray.count; i++) {
        DashboardCell* cell = self.dashBoardCellArray[i];
        if (i == self.dashBoardCellArray.count - 1) {
            [cell hideWithAnimateComplete:^(BOOL finished) {
                if (finished){
                            self.navigationController.navigationBar.hidden = NO;
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }];
        } else {
            [cell hideWithAnimateComplete:nil];
        }
    }
}

- (void)hideWithAnimateSynCompleteToController:(UIViewController*)controller
{
    for (int i = 0; i < self.dashBoardCellArray.count; i++) {
        DashboardCell* cell = self.dashBoardCellArray[i];
        if (i == 0) {
            [cell hideWithAnimateAfterDelay:delayAnimate * (self.dashBoardCellArray.count - i)complete:^(BOOL finished) {
                if (finished){
                    [self.navigationController pushViewController:controller animated:YES];
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

- (void)benbuClick:(id)sender
{
    NSLog(@"benbu click");
    [self closeDashboardCellUserInterface];
    CompetitionViewController* benbuController = [self.storyboard instantiateViewControllerWithIdentifier:@"competitionController"];
    [benbuController setCampusType:@(1)];
    [self hideWithAnimateSynCompleteToController:benbuController];
}

- (void)jiadingClick:(id)sender
{
    NSLog(@"jiading click");
    [self closeDashboardCellUserInterface];
    CompetitionViewController* jiadingController = [self.storyboard instantiateViewControllerWithIdentifier:@"competitionController"];
    [jiadingController setCampusType:@(2)];
    [self hideWithAnimateSynCompleteToController:jiadingController];
}

- (void)newsClick:(id)sender
{
    [self closeDashboardCellUserInterface];

    NSLog(@"news click");
    UIViewController* newsController = [self.storyboard instantiateViewControllerWithIdentifier:@"newsController"];
    [self hideWithAnimateSynCompleteToController:newsController];
}

- (void)settingClick:(id)sender
{
    NSLog(@"setting click");
    [self closeDashboardCellUserInterface];
    // UIViewController* settingController = [self.storyboard instantiateViewControllerWithIdentifier:@"settingController"];
    UIViewController* settingController = [self.storyboard instantiateViewControllerWithIdentifier:@"newAbout"];
    [self hideWithAnimateSynCompleteToController:settingController];
}

@end
