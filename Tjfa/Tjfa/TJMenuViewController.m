//
//  MenuViewController.m
//  Tjfa
//
//  Created by 邱峰 on 7/16/14.
//  Copyright (c) 2014 邱峰. All rights reserved.
//

#import "TJMenuViewController.h"
#import <RESideMenu.h>
#import "TJCompetitionDetailViewController.h"
#import "TJMatchViewController.h"
#import "TJTopScoreViewController.h"
#import "TJYellowCardViewController.h"
#import "TJRedCardViewController.h"
#import "TJGroupScoreViewController.h"
#import "TJTeamViewController.h"

@interface TJMenuViewController ()

@end

@implementation TJMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#define MATCH_VIEW_CONTROLLER_INDEX 0
#define SCORE_LIST_VIEW_CONTROLLER_INDEX 1
#define YELLOW_CARD_VIEW_CONTROLLER_INDEX 2
#define RED_CARD_VIEW_CONTROLLER_INDEX 3
#define GROUP_SCORE_VIEW_CONTROLLER_INDEX 4
#define TEAM_VIEW_CONTROLLER_INDEX 5

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJCompetitionDetailViewController *viewController;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == MATCH_VIEW_CONTROLLER_INDEX) {
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(TJMatchViewController.class)];
        self.sideMenuViewController.navigationItem.title = @"比 赛";
    }
    else if (indexPath.row == SCORE_LIST_VIEW_CONTROLLER_INDEX) {

        viewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(TJTopScoreViewController.class)];
        self.sideMenuViewController.navigationItem.title = @"射手榜";
    }
    else if (indexPath.row == YELLOW_CARD_VIEW_CONTROLLER_INDEX) {

        viewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(TJYellowCardViewController.class)];
        self.sideMenuViewController.navigationItem.title = @"黄 牌";
    }
    else if (indexPath.row == RED_CARD_VIEW_CONTROLLER_INDEX) {
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(TJRedCardViewController.class)];
        self.sideMenuViewController.navigationItem.title = @"红 牌";
    }
    else if (indexPath.row == GROUP_SCORE_VIEW_CONTROLLER_INDEX) {

        viewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(TJGroupScoreViewController.class)];
        self.sideMenuViewController.navigationItem.title = @"积 分";
    }
    else if (indexPath.row == TEAM_VIEW_CONTROLLER_INDEX) {
        viewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(TJTeamViewController.class)];
        self.sideMenuViewController.navigationItem.title = @"球 队";
    }

    if (viewController) {
        [self.sideMenuViewController setContentViewController:viewController animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    }
}

@end
