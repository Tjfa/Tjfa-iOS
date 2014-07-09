//
//  DashboardViewController.m
//  Tjfa
//
//  Created by 邱峰 on 6/28/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "DashboardViewController.h"
#import "DashboardCell.h"
#import "MatchListViewController.h"

@interface DashboardViewController () <UINavigationControllerDelegate>

@property (nonatomic, strong) DashboardCell* newsView;
@property (nonatomic, strong) DashboardCell* settingView;
@property (nonatomic, strong) DashboardCell* benbuView;
@property (nonatomic, strong) DashboardCell* jiadingView;

@property (nonatomic, strong) NSArray* dashBoardCellArray;

@end

@implementation DashboardViewController

const CGFloat dashboardButtonSize = 100;

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.delegate = self;
    self.view.backgroundColor = [UIColor appBackgroundColor];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self showDashboardButtonWithSyn];
}

- (CGFloat)getBaseHeightForDashboardButton
{
    return (self.view.frame.size.height - dashboardButtonSize * 4) / 2;
}

- (CGFloat)heightSpace
{
    return dashboardButtonSize + 10;
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
        [cell showWithAnimateAfterDelay:0.1 * i complete:nil];
    }
}

#pragma mark - getter & setter

- (DashboardCell*)benbuButton
{
    if (_benbuView == nil) {
        CGRect cellFrame = CGRectMake(0, [self getBaseHeightForDashboardButton], self.view.frame.size.width, dashboardButtonSize);

        _benbuView = [[DashboardCell alloc] initWithFrame:cellFrame image:[UIImage imageNamed:@"dashboardBenbu"] labelName:@"本部" direction:kRight target:self action:@selector(benbuClick:) dashboardSize:dashboardButtonSize];
        [self.view addSubview:_benbuView];
    }
    return _benbuView;
}

- (DashboardCell*)jiadingButton
{
    if (_jiadingView == nil) {

        CGRect cellFrame = CGRectMake(0, [self getBaseHeightForDashboardButton] + [self heightSpace], self.view.frame.size.width, dashboardButtonSize);

        _jiadingView = [[DashboardCell alloc] initWithFrame:cellFrame image:[UIImage imageNamed:@"dashboardJiading"] labelName:@"嘉定" direction:kLeft target:self action:@selector(jiadingClick:) dashboardSize:dashboardButtonSize];
        [self.view addSubview:_jiadingView];
    }
    return _jiadingView;
}

- (DashboardCell*)newsButton
{
    if (_newsView == nil) {

        CGRect cellFrame = CGRectMake(0, [self getBaseHeightForDashboardButton] + [self heightSpace] * 2, self.view.frame.size.width, dashboardButtonSize);

        _newsView = [[DashboardCell alloc] initWithFrame:cellFrame image:[UIImage imageNamed:@"dashboardNews"] labelName:@"新闻" direction:kRight target:self action:@selector(newsClick:) dashboardSize:dashboardButtonSize];
        [self.view addSubview:_newsView];
    }
    return _newsView;
}

- (DashboardCell*)settingButton
{
    if (_settingView == nil) {
        CGRect cellFrame = CGRectMake(0, [self getBaseHeightForDashboardButton] + [self heightSpace] * 3, self.view.frame.size.width, dashboardButtonSize);

        _settingView = [[DashboardCell alloc] initWithFrame:cellFrame image:[UIImage imageNamed:@"dashboardSetting"] labelName:@"关于" direction:kLeft target:self action:@selector(settingClick:) dashboardSize:dashboardButtonSize];
        [self.view addSubview:_settingView];
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
            [cell hideWithAnimateAfterDelay:0.1 * (self.dashBoardCellArray.count - i)complete:^(BOOL finished) {
                if (finished){
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }];
        } else {
            [cell hideWithAnimateAfterDelay:0.1 * (self.dashBoardCellArray.count - i)complete:nil];
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
    MatchListViewController* benbuController = [self.storyboard instantiateViewControllerWithIdentifier:@"competitionController"];
    [benbuController setCampusType:1];
    [self hideWithAnimateSynCompleteToController:benbuController];
}

- (void)jiadingClick:(id)sender
{
    NSLog(@"jiading click");
    [self closeDashboardCellUserInterface];
    MatchListViewController* jiadingController = [self.storyboard instantiateViewControllerWithIdentifier:@"competitionController"];
    [jiadingController setCampusType:2];
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
    UIViewController* newsController = [self.storyboard instantiateViewControllerWithIdentifier:@"settingController"];
    [self hideWithAnimateSynCompleteToController:newsController];
}

#pragma mark - Navigation

- (void)navigationController:(UINavigationController*)navigationController willShowViewController:(UIViewController*)viewController animated:(BOOL)animated
{
    if (viewController == self) {
        [navigationController setNavigationBarHidden:YES animated:YES];
    } else {
        [navigationController setNavigationBarHidden:NO animated:YES];
    }
}

@end
