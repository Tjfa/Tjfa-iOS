//
//  RootViewController.m
//  Tjfa
//
//  Created by 邱峰 on 7/16/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "RootViewController.h"
#import "UIColor+AppColor.h"
#import "MatchViewController.h"
#import "MenuViewController.h"
#import "CompetitionManager.h"
#import "MBProgressHUD+AppProgressView.h"

@interface RootViewController () <RESideMenuDelegate, UIGestureRecognizerDelegate>

@end

@implementation RootViewController
{
    BOOL isShow;
}

+ (id)allocWithRouterParams:(NSDictionary *)params
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RootViewController *instance = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    instance.compeitionId = params[@"competitionId"];
    return instance;
}

- (void)awakeFromNib
{
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(MenuViewController.class)];
    self.contentViewInPortraitOffsetCenterX = 0;
    self.contentViewController = [[UIViewController alloc] init];
    self.delegate = self;
    self.view.backgroundColor = [UIColor appRedColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
}

- (void)setupViews
{
    UIViewController<UIGestureRecognizerDelegate>* viewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(MatchViewController.class)];
    self.contentViewController = viewController;
    UITableViewController* rightViewController = (UITableViewController*)self.rightMenuViewController;
    rightViewController.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backBg"]];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.competition) {
        [self setupViews];
    } else {
        MBProgressHUD* progress = [MBProgressHUD progressHUDNetworkLoadingInView:self.navigationController.view];
        [progress show:YES];
        [self.view addSubview:progress];
        [[CompetitionManager sharedCompetitionManager] getCompeitionWithCompetitionId:self.compeitionId complete:^(Competition *competition, NSError *error) {
            [progress hide:YES];
            if (error) {
                [MBProgressHUD showWhenNetworkErrorInView:self.navigationController.view];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                self.competition = competition;
                [self setupViews];
            }
        }];
    }
    
}

- (IBAction)toggleMenu:(id)sender
{
    if (isShow) {
        [self hideMenuViewController];
    } else {
        [self presentRightMenuViewController];
    }
}

#pragma mark - RESide menu delegate

- (void)sideMenu:(RESideMenu*)sideMenu didShowMenuViewController:(UIViewController*)menuViewController
{
    isShow = YES;
}

- (void)sideMenu:(RESideMenu*)sideMenu didHideMenuViewController:(UIViewController*)menuViewController
{
    isShow = NO;
}

@end
