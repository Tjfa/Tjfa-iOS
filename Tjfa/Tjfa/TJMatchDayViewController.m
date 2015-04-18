//
//  TJMatchDayViewController.m
//  Tjfa
//
//  Created by 邱峰 on 4/18/15.
//  Copyright (c) 2015 邱峰. All rights reserved.
//

#import "TJMatchDayViewController.h"
#import "UIDevice+DeviceInfo.h"
#import "MBProgressHUD+AppProgressView.h"
#import "NSDate+Date2Str.h"
#import "TJMatch.h"
#import "TJMatchManager.h"
#import "TJTeamManager.h"
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>
#import <TSMessage.h>
#import <POP.h>

@interface TJMatchDayViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *teamABadgeImageView;
@property (weak, nonatomic) IBOutlet UILabel *teamANameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *teamBBadgeImageView;
@property (weak, nonatomic) IBOutlet UILabel *teamBNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *mainContainer;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *datePickerContainer;

@property (nonatomic, strong) UIView *gassiganBlurView;

@property (nonatomic, strong) TJTeam *teamA;
@property (nonatomic, strong) TJTeam *teamB;

#pragma mark - Animation Property

@property (nonatomic, strong) POPSpringAnimation *showDatePickerAnimation;

#pragma mark - Constraints IBOutlet

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datePickerContainerHeightConstraint;

@end

const NSTimeInterval anHourInterval = 3600;

@implementation TJMatchDayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self findMatch];
}

- (void)errorFindAndPop
{
    [MBProgressHUD showErrorProgressInView:nil withText:@"该比赛不存在"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)findMatch
{
    if (self.match) {
        [self setup];
    }
    else if (self.matchObjectId) {
        MBProgressHUD *progress = [MBProgressHUD progressHUDNetworkLoadingInView:nil withText:@"加载中.."];
        [[TJMatchManager sharedMatchManager] getMatchWithObjectId:self.matchObjectId complete:^(TJMatch *match, NSError *error) {
            [progress hide:YES];
            if (error) {
                [self errorFindAndPop];
            }
            else {
                self.match = match;
                [self setup];
            }
        }];
    }
    else if (self.matchId) {
        MBProgressHUD *progress = [MBProgressHUD progressHUDNetworkLoadingInView:nil withText:@"加载中.."];
        [[TJMatchManager sharedMatchManager] getMatchWithMatchId:self.matchId complete:^(TJMatch *match, NSError *error) {
            [progress hide:YES];
            if (error) {
                [self errorFindAndPop];
            }
            else {
                self.match = match;
                [self setup];
            }

        }];
    }
    else {
        [self errorFindAndPop];
    }
}

- (void)setup
{
    
    NSString *dateStr = [self.match.date date2str];
    NSInteger index = [dateStr rangeOfString:@" "].location;
    self.dateLabel.text = [dateStr substringToIndex:index];
    self.timeLabel.text = [dateStr substringFromIndex:index + 1];
    
    
    [[TJTeamManager sharedTeamManager] getTeamsByTeamId:self.match.teamAId complete:^(TJTeam *team, NSError *error) {
        if (error == nil) {
            self.teamA = team;
            self.teamANameLabel.text = self.teamA.name;
            [self.teamABadgeImageView setImageWithURL:[NSURL URLWithString:self.teamA.emblemPath] placeholderImage:[UIImage imageNamed:@"teamPlaceHolderA"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        }
    }];
    
    [[TJTeamManager sharedTeamManager] getTeamsByTeamId:self.match.teamBId complete:^(TJTeam *team, NSError *error) {
        if (error == nil) {
            self.teamB = team;
            self.teamBNameLabel.text = self.teamB.name;
            [self.teamBBadgeImageView setImageWithURL:[NSURL URLWithString:self.teamB.emblemPath] placeholderImage:[UIImage imageNamed:@"teamPlaceHolderB"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        }

    }];
    
}

#pragma mark - Getter & Setter

- (UIView *)gassiganBlurView
{
    if (_gassiganBlurView == nil) {
        if ([UIDevice iOSVersion] >= 8.0) {
            _gassiganBlurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        }
        else {
            _gassiganBlurView = [[UIView alloc] init];
            _gassiganBlurView.backgroundColor = [UIColor blackColor];
            _gassiganBlurView.alpha = 0.5;
        }
        _gassiganBlurView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gassiganBlurViewTapGesture:)];
        [_gassiganBlurView addGestureRecognizer:gesture];
    }
    return _gassiganBlurView;
}

- (POPSpringAnimation *)showDatePickerAnimate
{
    if (_showDatePickerAnimation == nil) {
        _showDatePickerAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
        _showDatePickerAnimation.springSpeed = 15;
        _showDatePickerAnimation.springBounciness = 20;
        _showDatePickerAnimation.fromValue = @(44);
        _showDatePickerAnimation.toValue = @(300);
    }
    return _showDatePickerAnimation;
}

#pragma mark - DatePicker

- (void)showDatePicker
{
    self.datePickerContainer.hidden = NO;
    [self.view addSubview:self.gassiganBlurView];
    [self.view bringSubviewToFront:self.datePickerContainer];
    [self.datePickerContainerHeightConstraint pop_addAnimation:self.showDatePickerAnimate forKey:@"showDatePickerAnimate"];
}

- (void)hideDatePicker
{
    [self.gassiganBlurView removeFromSuperview];
    self.datePickerContainer.hidden = YES;
}

#pragma mark - Action
- (IBAction)datePickerConfirmButtonPress:(UIButton *)sender
{
    [self hideDatePicker];
    
    NSDate *date = self.datePicker.date;
    
    NSString *subTitle = [[NSString alloc] initWithFormat:@"我会在%@的时候提醒你哦~~",date];

    [TSMessage showNotificationInViewController:self title:@"我知道啦" subtitle:subTitle type:TSMessageNotificationTypeSuccess duration:2.0f];
}

- (IBAction)datePickerCancelButtonPress:(UIButton *)sender
{
    [self hideDatePicker];
}

- (IBAction)remindButtonPress:(UIButton *)sender
{
    [self showDatePicker];
    //self.datePicker.date =
}

- (void)gassiganBlurViewTapGesture:(UITapGestureRecognizer *)gesture
{
    
}

@end
